import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#endif
import UserNotifications
import CoreLocation

@MainActor
final class TransitTrackingCoordinator: ObservableObject {
    enum TransitState: Equatable {
        case idle
        case tracking
        case approachingDestination
    }

    @Published private(set) var state: TransitState = .idle

    let motionManager: MotionManager
    let locationManager: LocationManager

    private var cancellables = Set<AnyCancellable>()

    init(
        motionManager: MotionManager = MotionManager(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.motionManager = motionManager
        self.locationManager = locationManager
        bind()
    }

    private func bind() {
        motionManager.$isVehicleTransitDetected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detected in
                guard let self, detected else { return }
                self.state = .tracking
                self.locationManager.startLocationTracking()
            }
            .store(in: &cancellables)

        locationManager.$isApproachingDestination
            .receive(on: DispatchQueue.main)
            .sink { [weak self] approaching in
                guard let self, approaching else { return }
                self.state = .approachingDestination
                self.notifyApproachingDestination()
                self.impactHaptic()
            }
            .store(in: &cancellables)
    }

    func start() {
        locationManager.requestPermissions()
        motionManager.startUpdates()
        state = .idle
    }

    func stop() {
        motionManager.stopUpdates()
        locationManager.stopLocationTracking()
        locationManager.stopGeofence()
        state = .idle
    }

    func setDestination(coordinate: CLLocationCoordinate2D, stationID: String, radius: Double = 500) {
        locationManager.startGeofence(center: coordinate, radius: radius, identifier: stationID)
    }

    private func notifyApproachingDestination() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "まもなく目的駅です"
            content.body = "降車の準備をしてください。"
            content.sound = .default

            let request = UNNotificationRequest(
                identifier: "approaching-destination",
                content: content,
                trigger: nil
            )
            UNUserNotificationCenter.current().add(request)
        }
    }

    private func impactHaptic() {
#if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
#endif
    }
}
