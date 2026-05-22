import XCTest
@testable import TrainIOSDesign

final class DelayNormalizerTests: XCTestCase {
    func testNormalizeSecondsToMinutes() {
        XCTAssertEqual(DelayNormalizer.normalizeDelayMinutes(120), 2)
    }

    func testNormalizeMinutesAsIsForSmallValues() {
        XCTAssertEqual(DelayNormalizer.normalizeDelayMinutes(5), 5)
    }

    func testNormalizeNilToZero() {
        XCTAssertEqual(DelayNormalizer.normalizeDelayMinutes(nil), 0)
    }
}
