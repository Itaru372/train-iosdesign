#if canImport(ActivityKit)
import ActivityKit

struct TrainActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var remainingMinutes: Int
        var remainingStations: Int
        var isDelayed: Bool
    }

    var routeName: String
    var destinationStationName: String
}
#endif
