//
//  OpenJournalIntent.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import SwiftData

struct OpenJournalIntent: OpenIntent {
    static var title: LocalizedStringResource = "Open Journal Entry"
    static var description = IntentDescription("Shows the details for a specific journal entry.")

    @Parameter(title: "Journal Entry")
    var target: JournalEntryEntity
    
    @Dependency
    private var navigationManager: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        do {
            let modelContext = DataModel.shared.modelContainer.mainContext
            let entityID = target.id
            let journals = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate { entry in
                entry.journalID == entityID
            }))
            guard let journal = journals.first else {
                throw IntentError.noEntity
            }
            navigationManager.openJournalEntry(journal)
            return .result()
        } catch {
            throw IntentError.noEntity
        }
    }
}

struct ComposeNewJournalEntry: AppIntent {
    static var title: LocalizedStringResource = "Compose New Journal Entry"
    static var description: IntentDescription? = IntentDescription("Opens the app and starts composing a new journal entry")
    
    @Dependency
    private var navigation: NavigationManager
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        navigation.composeNewJournalEntry()
        return .result()
    }
    
}
