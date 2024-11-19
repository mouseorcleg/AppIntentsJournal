/*
See LICENSE folder for this sample’s licensing information.

Abstract: The object that manages navigation in the app.

*/

import Foundation
import SwiftUI


@MainActor @Observable
final class NavigationManager {
    var searchText = ""
    var journalNavigationPath = NavigationPath()
    var journalEntry: JournalEntry?

    // MARK: Methods

    func openSearch(with criteria: String) {
        searchText = criteria
    }
    
    func composeNewJournalEntry() {
        journalEntry = JournalEntry()
    }
    
    func clearJournalEntry() {
        journalEntry = nil
    }
    
    func openJournalEntry(_ entry: JournalEntry) {
        journalNavigationPath = NavigationPath([entry])
    }
}
