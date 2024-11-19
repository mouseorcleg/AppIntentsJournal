/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An actor that provides a SwiftData model container for the whole app and widget,
 and implements actor-isolated tasks like SwiftData history processing.
*/

import SwiftUI
import SwiftData

actor DataModel {
    static let shared = DataModel()
    private init() {}
    
    nonisolated lazy var modelContainer: ModelContainer = {
        ValueTransformer.setValueTransformer(NSAttributedStringTransformer(), forName: .nsAttributedStringTransformer)
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: JournalEntry.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
}
