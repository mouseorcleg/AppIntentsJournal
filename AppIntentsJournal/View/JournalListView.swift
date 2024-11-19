/*
See LICENSE folder for this sample’s licensing information.

Abstract: A view that presents the app's user interface.

*/

import SwiftUI
import SwiftData
import CoreSpotlight
import Collections

struct JournalListView: View {
    @Environment(NavigationManager.self) private var navigation

    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack(path: $navigation.journalNavigationPath) {
            FilteredJournalListView(searchTerm: navigation.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigation.composeNewJournalEntry()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: JournalEntry.self) { entry in
                JournalDetailView(journalEntry: entry)
            }
            .navigationTitle("AppIntentsJournal")
            .sheet(item: $navigation.journalEntry, onDismiss: {
                navigation.clearJournalEntry()
            }) { entry in
                JournalEntryView(journalEntry: entry)
            }
        }
        .searchable(text: $navigation.searchText)
    }
}

struct FilteredJournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.entryDate, order: .reverse)
    private var journalEntries: [JournalEntry]
    private var isInSearchMode = false

    @Environment(\.dismissSearch) private var dismissSearch

    init(searchTerm: String) {
        if !searchTerm.isEmpty {
            isInSearchMode = true
            _journalEntries = Query(filter: #Predicate<JournalEntry> {
                $0.title.contains(searchTerm) 
            }, sort: \JournalEntry.entryDate, order: .reverse)
        }
    }

    static let todayString = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: Date.now)
    }()

    var body: some View {
        let calendar = Calendar.current
        let groupedEntries = OrderedDictionary(grouping: journalEntries, by: { entry in
            if calendar.isDateInToday(entry.entryDate) { return Self.todayString }
            else { return calendar.startOfDay(for: entry.entryDate).formatted(.relative(presentation: .named)) as String }
        })
        List {
            ForEach(Array(groupedEntries.keys), id: \.self) { group in
                Section(header: Text(group)) {
                    ForEach(groupedEntries[group] ?? []) { entry in
                        NavigationLink(value: entry) {
                            JournalEntryCell(journalEntry: entry)
                        }
                    }
                    .onDelete { indexSet in
                        deleteEntries(entries: indexSet.map { index in (groupedEntries[group] ?? [])[index] })
                    }
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20))
            }
        }
        .overlay {
            if journalEntries.isEmpty {
                if isInSearchMode {
                    ContentUnavailableView.search
                }
                else {
                    ContentUnavailableView {
                        Label("Start journaling", systemImage: "figure.mind.and.body")
                    } description: {
                        Text("Keep track of your developer mindset.\nAdd a new entry to get started.")
                    }
                }
            }
        }
    }

    private func deleteEntries(entries: [JournalEntry]) {
        let ids = entries.map(\.journalID)
        withAnimation {
            entries.forEach { modelContext.delete($0) }
            try? modelContext.save()
        }
        Task {
            try? await CSSearchableIndex.default().deleteAppEntities(identifiedBy: ids, ofType: JournalEntryEntity.self)
        }

        if let count = try? modelContext.fetchCount(FetchDescriptor<JournalEntry>()),
           count == 0 {
            dismissSearch()
        }
    }
}

struct JournalEntryCell: View {
    var journalEntry: JournalEntry

    var body: some View {
        HStack() {
            Text(journalEntry.stateOfMind.symbol())
                .font(.title)
                .frame(width: 50, height: 50)
                .background(journalEntry.stateOfMind.accentColor(), in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            VStack(alignment: .leading) {
                Text(journalEntry.stateOfMind.localizedName())
                    .font(.headline)
                Text(journalEntry.title.isEmpty ? "No Title" : journalEntry.title)
                    .italic(journalEntry.title.isEmpty)
                    .font(.subheadline)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { dimensions in dimensions[.leading] }
    }
}
