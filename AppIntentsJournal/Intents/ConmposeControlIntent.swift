//
//  ConmposeControlIntent.swift
//  AppIntentsJournal
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents

struct ComposeControlAction: AppIntent {

    static let title: LocalizedStringResource = "Compose Journal Entry"

    static var isDiscoverable = false

    func perform() async throws -> some IntentResult & OpensIntent {
        
        return .result(opensIntent: ComposeNewJournalEntry())
    }
}
