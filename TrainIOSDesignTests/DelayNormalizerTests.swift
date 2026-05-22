import XCTest
@testable import TrainIOSDesign

final class DelayNormalizerTests: XCTestCase {
    func testNormalizeSecondsToMinutes() {
        XCTAssertEqual(DelayNormalizer.normalizeDelaySecondsToMinutes(delayInSeconds: 120), 2)
    }

    func testNormalizeMinutesAsIsForSmallValues() {
        XCTAssertEqual(DelayNormalizer.normalizeDelaySecondsToMinutes(delayInSeconds: 5), 1)
    }

    func testNormalizeNilToZero() {
        XCTAssertEqual(DelayNormalizer.normalizeDelaySecondsToMinutes(delayInSeconds: nil), 0)
    }
}
