//
//  MoodCheckInIntent.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import SwiftData
import CoreSpotlight

struct MoodCheckInIntent: AppIntent {
    static var title: LocalizedStringResource = "Mood Check-In"
    static var description: IntentDescription? = IntentDescription(stringLiteral: "Adds a mood entry to the journal")
    
    @Parameter(title: "How are you?")
    var mood: DeveloperStateOfMind
    
    var target: JournalEntryEntity?
    
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> & ProvidesDialog {
        let entry = JournalEntry(stateOfMind: mood)
        
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        modelContext.insert(entry)
        try modelContext.save()
        
        try await CSSearchableIndex.default().indexAppEntities([entry.entity])
        
        let dialog = IntentDialog(full: "I created a new journal entry for you!", supporting: "Noted ✍️")
        
        return .result(value: entry.entity, dialog: dialog)
    }
}
