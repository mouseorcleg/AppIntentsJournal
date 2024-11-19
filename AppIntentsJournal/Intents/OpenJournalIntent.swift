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
    static var description: IntentDescription? = IntentDescription(stringLiteral: "Shows details for journal entry")
    
    @Parameter(title: "Journal Entry")
    var target: JournalEntryEntity
    
    @Dependency
    private var navigation: NavigationManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        do {
            let modelContext = DataModel.shared.modelContainer.mainContext
            let entityID = target.id
            
            let entries = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate { entry in
                entry.journalID == entityID
            }))

            
            guard let firstEntry = entries.first else {
                throw IntentError.noEntity
            }
            
            navigation.openJournalEntry(firstEntry)
            
            return .result()
        } catch {
            throw IntentError.noEntity
        }
    }
}
