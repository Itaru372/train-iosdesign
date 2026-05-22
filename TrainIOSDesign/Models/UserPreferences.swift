import Foundation
import SwiftData

@Model
final class FavoriteRoute {
    var routeID: String
    var railwayID: String
    var destinationStationID: String
    var createdAt: Date

    init(routeID: String, railwayID: String, destinationStationID: String, createdAt: Date = .now) {
        self.routeID = routeID
        self.railwayID = railwayID
        self.destinationStationID = destinationStationID
        self.createdAt = createdAt
    }
}

@Model
final class UserPreference {
    var notificationsEnabled: Bool
    var geofenceRadiusMeters: Double
    var updatedAt: Date

    init(
        notificationsEnabled: Bool = true,
        geofenceRadiusMeters: Double = 500,
        updatedAt: Date = .now
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.geofenceRadiusMeters = geofenceRadiusMeters
        self.updatedAt = updatedAt
    }
}
