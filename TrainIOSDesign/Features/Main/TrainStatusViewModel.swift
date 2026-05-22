import Foundation
import Combine
import UserNotifications
import SwiftData
import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif

@MainActor
final class TrainStatusViewModel: ObservableObject {
    @Published var routeName: String = "路線未設定"
    @Published var destinationStationName: String = "目的駅未設定"
    @Published var remainingMinutes: Int = 0
    @Published var remainingStations: Int = 0
    @Published var statusText: String = "待機中"
    @Published var isDelayed: Bool = false

    let coordinator: TransitTrackingCoordinator
    private let client: ODPTClient?
    private var cancellables = Set<AnyCancellable>()

#if canImport(ActivityKit)
    private var currentActivity: Activity<TrainActivityAttributes>?
#endif

    init(
        coordinator: TransitTrackingCoordinator = TransitTrackingCoordinator(),
        client: ODPTClient? = AppConfiguration.odptAPIKey.map { ODPTClient(apiKey: $0) }
    ) {
        self.coordinator = coordinator
        self.client = client
        bindCoordinator()
    }

    func startTracking() {
        guard let client else {
            statusText = "ODPT APIキー未設定"
            assertionFailure("ODPT API key is not configured.")
            return
        }
        requestNotificationPermission()
        coordinator.start()
        statusText = "移動検知待機中"

        Task {
            await client.startPollingTrainInformation(railway: nil) { [weak self] info in
                self?.consume(trainInformation: info)
            }
        }
    }

    func stopTracking() {
        coordinator.stop()
        if let client {
            Task { await client.stopPolling() }
        }
        statusText = "停止中"
        Task { await endLiveActivity() }
    }

    func setMockRoute() {
        routeName = "東京メトロ 東西線"
        destinationStationName = "日本橋"
        remainingStations = 4
        recalculateETA(scheduledDate: .now.addingTimeInterval(12 * 60), delaySeconds: nil)
        statusText = "追跡中"
    }

    func configureDestination(_ station: ODPTStation) {
        guard let coordinate = station.coordinate else { return }
        coordinator.setDestination(
            coordinate: coordinate,
            stationID: station.id ?? UUID().uuidString
        )
        destinationStationName = station.title?["ja"] ?? destinationStationName
    }

    private func bindCoordinator() {
        coordinator.$state
            .sink { [weak self] state in
                withAnimation {
                    switch state {
                    case .idle:
                        self?.statusText = "待機中"
                    case .tracking:
                        self?.statusText = "追跡中"
                    case .approachingDestination:
                        self?.statusText = "まもなく到着"
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func consume(trainInformation: [ODPTTrainInformation]) {
        guard let first = trainInformation.first else { return }
        isDelayed = first.normalizedDelayMinutes > 0
        if let railway = first.railway {
            routeName = railway
        }

        if isDelayed {
            recalculateETA(
                scheduledDate: .now.addingTimeInterval(10 * 60),
                delaySeconds: first.delay
            )
        } else {
            recalculateETA(
                scheduledDate: .now.addingTimeInterval(8 * 60),
                delaySeconds: nil
            )
        }
    }

    private func recalculateETA(scheduledDate: Date, delaySeconds: Int?) {
        let estimate = ETAEstimator.estimate(from: scheduledDate, delaySeconds: delaySeconds)
        remainingMinutes = estimate.remainingMinutes
        Task { await updateLiveActivity() }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    private func updateLiveActivity() async {
#if canImport(ActivityKit)
        let attributes = TrainActivityAttributes(
            routeName: routeName,
            destinationStationName: destinationStationName
        )
        let content = TrainActivityAttributes.ContentState(
            remainingMinutes: remainingMinutes,
            remainingStations: remainingStations,
            isDelayed: isDelayed
        )

        if let currentActivity {
            await currentActivity.update(
                ActivityContent(state: content, staleDate: Date().addingTimeInterval(60))
            )
        } else {
            currentActivity = try? Activity<TrainActivityAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: content, staleDate: Date().addingTimeInterval(60))
            )
        }
#endif
    }

    private func endLiveActivity() async {
#if canImport(ActivityKit)
        guard let currentActivity else { return }
        let finalState = TrainActivityAttributes.ContentState(
            remainingMinutes: remainingMinutes,
            remainingStations: remainingStations,
            isDelayed: isDelayed
        )
        await currentActivity.end(
            ActivityContent(state: finalState, staleDate: nil),
            dismissalPolicy: .immediate
        )
        self.currentActivity = nil
#endif
    }
}
