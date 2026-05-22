import Foundation
import CoreMotion
import Combine

final class MotionManager: ObservableObject {
    @Published private(set) var isVehicleTransitDetected = false

    private let activityManager = CMMotionActivityManager()
    private let queue = OperationQueue()
    private var wasWalking = false

    func startUpdates() {
        guard CMMotionActivityManager.isActivityAvailable() else { return }
        activityManager.startActivityUpdates(to: queue) { [weak self] activity in
            guard let self, let activity else { return }
            let currentlyWalking = activity.walking || activity.running
            let currentlyVehicle = activity.automotive

            if Self.didTransitionToTransit(
                previousWasWalking: self.wasWalking,
                currentlyWalking: currentlyWalking,
                currentlyVehicle: currentlyVehicle
            ) {
                DispatchQueue.main.async {
                    self.isVehicleTransitDetected = true
                }
            }

            if currentlyWalking {
                self.wasWalking = true
            } else if currentlyVehicle {
                self.wasWalking = false
            }
        }
    }

    func stopUpdates() {
        activityManager.stopActivityUpdates()
    }

    static func didTransitionToTransit(
        previousWasWalking: Bool,
        currentlyWalking: Bool,
        currentlyVehicle: Bool
    ) -> Bool {
        previousWasWalking && !currentlyWalking && currentlyVehicle
    }
}
