/*
See LICENSE folder for this sample’s licensing information.

Abstract: The main app structure.

*/

import SwiftUI
import SwiftData
import AppIntents

@main
struct AppIntentsJournalApp: App {
    let modelContainer = DataModel.shared.modelContainer
    let navigationManager: NavigationManager
    
    init() {
        let navigationManager = NavigationManager()
        self.navigationManager = navigationManager

        //key values store for app intents
        //allows to check if dependencies are thee before running a shortcuts
        AppDependencyManager.shared.add(dependency: navigationManager)
    }
    
    var body: some Scene {
        WindowGroup {
            JournalListView()
        }
        .modelContainer(modelContainer)
        .environment(navigationManager)
    }
}
