import XCTest
@testable import TrainIOSDesign

final class ETAEstimatorTests: XCTestCase {
    func testEstimateWithoutDelay() {
        let base = Date().addingTimeInterval(5 * 60)
        let estimate = ETAEstimator.estimate(from: base, delayInSeconds: nil)
        XCTAssertGreaterThanOrEqual(estimate.remainingMinutes, 4)
    }

    func testEstimateWithSecondDelay() {
        let base = Date().addingTimeInterval(5 * 60)
        let estimate = ETAEstimator.estimate(from: base, delayInSeconds: 180)
        XCTAssertGreaterThanOrEqual(estimate.remainingMinutes, 7)
    }
}
