/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract: App Shortcuts defined by the app.
 
 */

import AppIntents
import Foundation

//this protocolcan be used ones in the app
class JournalShortcuts: AppShortcutsProvider {
    
    static var shortcutTileColor = ShortcutTileColor.navy
    
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(intent: MoodCheckInIntent(),
                    phrases: [
                        //NB: every phrase should have app name otherwise Siri wouldn't use them
                        "Do a mood chek-in in \(.applicationName)",
                        "State of mind check-in in \(.applicationName)"
                    ],
                    shortTitle: "Mood check-in",
                    systemImageName: "apple.meditate")
    ]
}
