import Foundation

enum AppConfiguration {
    static var odptAPIKey: String? {
        if let value = Bundle.main.object(forInfoDictionaryKey: "ODPTAPIKey") as? String,
           !value.isEmpty,
           !value.contains("$(") {
            return value
        }

        if let envValue = ProcessInfo.processInfo.environment["ODPT_API_KEY"],
           !envValue.isEmpty {
            return envValue
        }
        return nil
    }
}
