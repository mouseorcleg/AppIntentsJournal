/*
See LICENSE folder for this sample’s licensing information.

Abstract: A view that allows creating or editing an individual journal entry.

*/

import SwiftUI
import SwiftData
import CoreSpotlight

struct JournalEntryView : View {
    enum JournalEntryViewMode: CaseIterable{
        case edit
        case create

        func buttonTitle() -> String {
            switch self {
            case .edit: return String(localized: "Done", comment: "Button title when done editing journal entry")
            case .create: return String(localized: "Add", comment: "Button title when done creating a new journal entry")
            }
        }

        func navigationTitle() -> String {
            switch self {
            case .edit: return String(localized: "Edit Journal Entry", comment: "Navigation title when editing a journal entry")
            case .create: return String(localized: "New Journal Entry", comment: "Navigation title when creating a new journal entry")
            }
        }
    }
    
    @Environment(\.modelContext) private var modelContext
    @Bindable var journalEntry: JournalEntry
    @Environment(\.dismiss) var dismiss
    var mode: JournalEntryViewMode
    
    @State private var title:String
    @State private var message: NSAttributedString
    @State private var mood: DeveloperStateOfMind

    @State private var textEditorPadding: CGFloat = 0

    init (journalEntry: JournalEntry, mode: JournalEntryViewMode = .create) {
        self.journalEntry = journalEntry
        self.mode = mode
        mood = journalEntry.stateOfMind
        title = journalEntry.title
        message = journalEntry.message
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("How are you feeling today?", selection: $mood) {
                        ForEach(DeveloperStateOfMind.allCases) { mood in
                            Text(mood.displayName())
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section {
                    TextField("Title", text: $title)
						.font(.headline)
                    JournalTextEditor(text: $message, sidePadding: $textEditorPadding)
                        .padding(-textEditorPadding)
                        .frame(height: 200)
                        .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle(mode.navigationTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(mode.buttonTitle()) {
                        withAnimation {
                            save()
                        }
                        Task{
                            try? await CSSearchableIndex.default().indexAppEntities([journalEntry.entity])
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func save() {
        journalEntry.title = title
        journalEntry.message = message
        journalEntry.stateOfMind = mood
        if mode == .create {
           modelContext.insert(journalEntry)
        }
        try? modelContext.save()
    }
}
