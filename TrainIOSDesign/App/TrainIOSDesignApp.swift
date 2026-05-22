import SwiftUI
import SwiftData

@main
struct TrainIOSDesignApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteRoute.self,
            UserPreference.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer. Check schema compatibility, persistent store availability, and disk space. Error: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
