//
//  NewJournalEntryIntent.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import CoreLocation
import SwiftData
import CoreSpotlight

enum IntentError: Error {
    case noEntity
}

@AssistantIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    var title: String?
    var message: AttributedString
    var entryDate: Date?
    var location: CLPlacemark?
    
    @Parameter(default: [])
    var mediaItems: [IntentFile]
    
    @Parameter(title: "State of Mind")
    var mood: DeveloperStateOfMind?
    
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        do {
        //NOTE: SwiftData thing happening
        //not a main context
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        let entry = JournalEntry(title: title, message: message, entryDate: entryDate, stateOfMind: mood)
        modelContext.insert(entry)
        try modelContext.save()
        
        try await CSSearchableIndex.default().indexAppEntities([entry.entity])
        
        return .result(value: entry.entity)
        } catch {
            throw IntentError.noEntity
        }
    }
}

@AssistantIntent(schema: .journal.search)
struct SearchJournalEntriesIntent: ShowInAppSearchResultsIntent {
    static var searchScopes: [StringSearchScope] = [.general]
    
    var criteria: StringSearchCriteria
    
    @Dependency
    var navigation: NavigationManager
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        
        navigation.openSearch(with: criteria.term)
        
        return .result()
    }
}

