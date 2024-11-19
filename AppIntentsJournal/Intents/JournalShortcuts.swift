/*
See LICENSE folder for this sample’s licensing information.

Abstract: App Shortcuts defined by the app.

*/

import AppIntents
import Foundation

class JournalShortcuts: AppShortcutsProvider {
    /// The color the system uses to display the App Shortcuts in the Shortcuts app. This is currently unused.
    static var shortcutTileColor = ShortcutTileColor.navy
    
    /**
     This sample app contains several examples of different intents, but only the intents this array describes make sense as App Shortcuts.
     Put the App Shortcut most people will use as the first item in the array. This first shortcut shouldn't bring the app to the foreground.
     
     Every phrase that people use to invoke an App Shortcut needs to contain the app name, using the `applicationName` placeholder in the provided
     phrase text, as well as any app name synonyms declared in the `INAlternativeAppNames` key of the app's `Info.plist` file. These phrases are
     localized in a string catalog named `AppShortcuts.xcstrings`.
     */
    static var appShortcuts: [AppShortcut] = []
}
