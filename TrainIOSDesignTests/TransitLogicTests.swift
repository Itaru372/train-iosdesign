import XCTest
import CoreLocation
@testable import TrainIOSDesign

final class TransitLogicTests: XCTestCase {
    func testWalkingToVehicleTransition() {
        XCTAssertTrue(
            MotionManager.didTransitionToTransit(
                previousWasWalking: true,
                currentlyWalking: false,
                currentlyVehicle: true
            )
        )
    }

    func testNoTransitionWhenStillWalking() {
        XCTAssertFalse(
            MotionManager.didTransitionToTransit(
                previousWasWalking: true,
                currentlyWalking: true,
                currentlyVehicle: false
            )
        )
    }

    func testWithin500mGeofence() {
        let station = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125)
        let nearby = CLLocationCoordinate2D(latitude: 35.684000, longitude: 139.770000)
        XCTAssertTrue(LocationManager.isWithinGeofence(current: nearby, destination: station, radiusMeters: 500))
    }
}
