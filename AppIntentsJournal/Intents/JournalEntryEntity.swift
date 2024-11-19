//
//  JournalEntryEntity.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import CoreLocation
import CoreSpotlight

@AssistantEntity(schema: .journal.entry)
struct JournalEntryEntity {
    
    struct JournalEntryEntityQuery: EntityStringQuery {
        func entities(for identifiers: [JournalEntryEntity.ID]) async throws -> [JournalEntryEntity] { [] }
        func entities(matching string: String) async throws -> [JournalEntryEntity] { [] }
    }
    
    static var defaultQuery = JournalEntryEntityQuery()
    var displayRepresentation: DisplayRepresentation { "Unimplemented" }
    
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
