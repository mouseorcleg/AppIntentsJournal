/*
See LICENSE folder for this sample’s licensing information.

Abstract: A view that shows an individual journal entry.

*/

import SwiftUI

struct JournalDetailView: View {
    var journalEntry: JournalEntry
    @State private var isEditSheetPresented: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(journalEntry.title)
                    .font(.largeTitle).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(journalEntry.stateOfMind.displayName())
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .background(journalEntry.stateOfMind.accentColor(),
                                in: RoundedRectangle(cornerRadius: 20.0, style: .continuous))
            }
            .padding([.horizontal, .top])
            .frame(maxWidth: .infinity)
            List {
                Text(journalEntry.messageAsAttributedString)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
            }
            .frame(maxHeight: .infinity)
            .listStyle(.insetGrouped)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditSheetPresented = true
                } label: {
                    Text(String(localized: "Edit", comment: "Button title to edit journal entry"))
                }
            }
        }
        .sheet(isPresented: $isEditSheetPresented, onDismiss: {
            isEditSheetPresented = false
        }) {
            JournalEntryView(journalEntry: journalEntry, mode: .edit)
        }
    }
}
