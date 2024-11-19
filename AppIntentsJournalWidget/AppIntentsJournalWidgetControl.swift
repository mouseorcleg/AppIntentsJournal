//
//  AppIntentsJournalWidgetControl.swift
//  AppIntentsJournalWidget
//
//  Created by Maria Kharybina on 19/11/2024.
//

import AppIntents
import SwiftUI
import WidgetKit

struct AppIntentsJournalWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.apple-evangelism.com.AppIntentsJournal.AppIntentsJournalWidget"
        ) {
            ControlWidgetButton(action: ComposeControlAction()) {
                Label("Create Entry", systemImage: "rectangle.and.pencil.and.ellipsis")
            }
        }
        .displayName("Compose")
        .description("A control that starts writing a new journal entry.")
    }
}


