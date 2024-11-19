//
//  JournalEntryEntity.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import CoreLocation
import CoreSpotlight
import SwiftData

@AssistantEntity(schema: .journal.entry)
struct JournalEntryEntity {
    
    static let defaultQuery = JournalQuery()
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: title ?? "No Title")
    }
    
    let id: UUID
    
    var title: String?
    var message: AttributedString?
    var mediaItems: [IntentFile]
    var entryDate: Date?
    var location: CLPlacemark?
    var mood: DeveloperStateOfMind?
    
    init(item: JournalEntry) {
        id = item.journalID
        title = item.title
        entryDate = item.entryDate
        message = item.messageAsAttributedString
        mood = item.stateOfMind
    }
}

extension JournalEntryEntity: IndexedEntity, Identifiable {
    var attributeSet: CSSearchableItemAttributeSet {
        let attributeSet = defaultAttributeSet
        attributeSet.title = title
        if let message {
            attributeSet.contentDescription = String(message.characters[...])
        }
        return attributeSet
    }
}

struct JournalQuery: EntityQuery {
    
    //used for Spotligh
    @MainActor
    func entities(for identifiers: [JournalEntryEntity.ID]) async throws -> [JournalEntryEntity] {
        let modelContext = DataModel.shared.modelContainer.mainContext
        let journals = try modelContext.fetch(FetchDescriptor<JournalEntry>(predicate: #Predicate { identifiers.contains($0.journalID) }))
        return journals.map { JournalEntryEntity(item: $0) }
    }
    
    func suggestedEntities() async throws -> [JournalEntryEntity] {
        let modelContext = ModelContext(DataModel.shared.modelContainer)
        var descriptor = FetchDescriptor<JournalEntry>(predicate: #Predicate { _ in true})
        descriptor.fetchLimit = 8
        let journals = try modelContext.fetch(descriptor)
        return journals.map { JournalEntryEntity(item: $0) }
    }
}
