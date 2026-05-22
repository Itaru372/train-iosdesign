import Foundation
import CoreLocation

struct ODPTTrainInformation: Codable, Identifiable {
    let context: String?
    let id: String?
    let type: String?
    let date: Date?
    let valid: Date?
    let operatorID: String?
    let railway: String?
    let trainInformationStatus: String?
    let trainInformationText: String?
    let delay: Int?

    var identifier: String {
        id ?? UUID().uuidString
    }

    var normalizedDelayMinutes: Int {
        DelayNormalizer.normalizeDelayMinutes(delay)
    }

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id = "owl:sameAs"
        case type = "@type"
        case date = "dc:date"
        case valid = "dct:valid"
        case operatorID = "odpt:operator"
        case railway = "odpt:railway"
        case trainInformationStatus = "odpt:trainInformationStatus"
        case trainInformationText = "odpt:trainInformationText"
        case delay = "odpt:delay"
    }
}

struct ODPTRailway: Codable, Identifiable {
    let context: String?
    let id: String?
    let type: String?
    let title: [String: String]?
    let stationOrder: [StationOrder]?

    struct StationOrder: Codable {
        let station: String
        let index: Int
    }

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id = "owl:sameAs"
        case type = "@type"
        case title = "dc:title"
        case stationOrder = "odpt:stationOrder"
    }
}

struct ODPTStation: Codable, Identifiable {
    let context: String?
    let id: String?
    let type: String?
    let title: [String: String]?
    let railway: String?
    let latitude: Double?
    let longitude: Double?

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id = "owl:sameAs"
        case type = "@type"
        case title = "dc:title"
        case railway = "odpt:railway"
        case latitude = "geo:lat"
        case longitude = "geo:long"
    }
}

struct ODPTTrain: Codable, Identifiable {
    let context: String?
    let id: String?
    let type: String?
    let date: Date?
    let railway: String?
    let fromStation: String?
    let toStation: String?
    let delay: Int?
    let carComposition: Int?

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id = "owl:sameAs"
        case type = "@type"
        case date = "dc:date"
        case railway = "odpt:railway"
        case fromStation = "odpt:fromStation"
        case toStation = "odpt:toStation"
        case delay = "odpt:delay"
        case carComposition = "odpt:carComposition"
    }
}

enum DelayNormalizer {
    static func normalizeDelayMinutes(_ rawDelay: Int?) -> Int {
        guard let rawDelay, rawDelay > 0 else { return 0 }
        if rawDelay >= 60 {
            return Int(ceil(Double(rawDelay) / 60.0))
        }
        return rawDelay
    }
}

struct ETAEstimate: Equatable {
    let scheduledDate: Date
    let adjustedDate: Date
    let remainingMinutes: Int
}

enum ETAEstimator {
    static func estimate(from scheduledDate: Date, delaySeconds: Int?) -> ETAEstimate {
        let normalizedSeconds: Int
        if let delaySeconds {
            normalizedSeconds = delaySeconds >= 60 ? delaySeconds : delaySeconds * 60
        } else {
            normalizedSeconds = 0
        }

        let adjustedDate = scheduledDate.addingTimeInterval(TimeInterval(max(0, normalizedSeconds)))
        let remaining = max(0, Int(ceil(adjustedDate.timeIntervalSinceNow / 60)))
        return ETAEstimate(scheduledDate: scheduledDate, adjustedDate: adjustedDate, remainingMinutes: remaining)
    }
}
