/*
See LICENSE folder for this sample’s licensing information.

Abstract: The model object for a journal entry.

*/

import Foundation
import SwiftData
import AppIntents
import SwiftUI
import UIKit

enum JournalEntryError: Error {
    case insertionFailed
    case updateFailed
    case donationFailed
}

enum DeveloperStateOfMind: String, Codable, CaseIterable, Identifiable, AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "State of Mind")
    
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .none: DisplayRepresentation(title: LocalizedStringResource("none", table: "StatesOfMind")),
        .creative: DisplayRepresentation(title: LocalizedStringResource("creative", table: "StatesOfMind")),
        .productive: DisplayRepresentation(title: LocalizedStringResource("productive", table: "StatesOfMind")),
        .coding: DisplayRepresentation(title: LocalizedStringResource("coding", table: "StatesOfMind")),
        .wantToCode: DisplayRepresentation(title: LocalizedStringResource("wantToCode", table: "StatesOfMind")),
        .wantToDebug: DisplayRepresentation(title: LocalizedStringResource("wantToDebug", table: "StatesOfMind")),
        .codeAndChill: DisplayRepresentation(title: LocalizedStringResource("codeAndChill", table: "StatesOfMind")),
        .bugReporting: DisplayRepresentation(title: LocalizedStringResource("bugReporting", table: "StatesOfMind")),
        .testing: DisplayRepresentation(title: LocalizedStringResource("testing", table: "StatesOfMind")),
        .headBanging: DisplayRepresentation(title: LocalizedStringResource("headBanging", table: "StatesOfMind")),
        .stuck: DisplayRepresentation(title: LocalizedStringResource("stuck", table: "StatesOfMind")),
        .noIdeas: DisplayRepresentation(title: LocalizedStringResource("noIdeas", table: "StatesOfMind")),
        .coffee: DisplayRepresentation(title: LocalizedStringResource("coffee", table: "StatesOfMind")),
        .designing: DisplayRepresentation(title: LocalizedStringResource("designing", table: "StatesOfMind")),
        .nerdingOut: DisplayRepresentation(title: LocalizedStringResource("nerdingOut", table: "StatesOfMind")),
        .cowboy: DisplayRepresentation(title: LocalizedStringResource("cowboy", table: "StatesOfMind")),
        .refactoring: DisplayRepresentation(title: LocalizedStringResource("refactoring", table: "StatesOfMind")),
        .overwhelmed: DisplayRepresentation(title: LocalizedStringResource("overwhelmed", table: "StatesOfMind")),
        .zombie: DisplayRepresentation(title: LocalizedStringResource("zombie", table: "StatesOfMind"))
    ]

    case none
    case creative
    case productive
    case coding
    case wantToCode
    case wantToDebug
    case codeAndChill
    case bugReporting
    case testing
    case headBanging
    case stuck
    case noIdeas
    case coffee
    case designing
    case nerdingOut
    case cowboy
    case refactoring
    case overwhelmed
    case zombie

    func symbol() -> String {
        switch self {
            case .none: return ""
            case .creative: return "💡"
            case .productive: return "⚡️"
            case .coding: return "🧘"
            case .wantToCode: return "🧑‍💻"
            case .wantToDebug: return "👨‍💻"
            case .codeAndChill: return "😎"
            case .bugReporting: return "🐞"
            case .testing: return "🔎"
            case .headBanging: return "💥"
            case .stuck: return "⛔️"
            case .noIdeas: return "🪫"
            case .coffee: return "☕️"
            case .designing: return "🎨"
            case .nerdingOut: return "🤓"
            case .cowboy: return "🤠"
            case .refactoring: return "👷"
            case .overwhelmed: return "😰"
            case .zombie: return "🧟"
        }
    }

    func accentColor() -> Color {
        var color: Color
        switch self {
            case .none: color = .mint
            case .creative: color = .green
            case .productive: color = .yellow
            case .coding: color = .blue
            case .wantToCode: color = .blue
            case .wantToDebug: color = .yellow
            case .codeAndChill: color = .green
            case .bugReporting: color = .orange
            case .testing: color = .blue
            case .headBanging: color = .red
            case .stuck: color = .red
            case .noIdeas: color = .pink
            case .coffee: color = .brown
            case .designing: color = .green
            case .nerdingOut: color = .yellow
            case .cowboy: color = .brown
            case .refactoring: color = .green
            case .overwhelmed: color = .red
            case .zombie: color = .primary
        }
        return Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
            ? UIColor(color).withProminence(.quaternary)
            : UIColor(color.mix(with: Color(UIColor.systemBackground), by: 0.8))
        } )
    }

    func localizedName() -> String {
        String(localized: .init(rawValue), table: "StatesOfMind")
    }
    
    func displayName() -> String {
        "\(symbol()) \(localizedName())"
    }

    var id: Self { self }
}

@Model
final class JournalEntry {
    @Attribute(.unique) var journalID: UUID
    var entryDate: Date
    var title: String = ""

    @Attribute(.transformable(by: NSAttributedStringTransformer.self))
    var message: NSAttributedString

    var messageAsAttributedString: AttributedString {
        AttributedString(message)
    }
    
    var stateOfMind = DeveloperStateOfMind.creative

    init(title: String? = "", message: AttributedString? = "", entryDate: Date? = .now, stateOfMind: DeveloperStateOfMind? = .creative) {
        self.title = title ?? ""
        self.entryDate = entryDate ?? .now
        journalID = UUID()
        var formattedMessage = message ?? ""
        formattedMessage.font = .systemFont(ofSize: UIFont.labelFontSize)
        formattedMessage.foregroundColor = .label
        self.message = NSAttributedString(formattedMessage)
        self.stateOfMind = stateOfMind ?? .creative
    }
}

extension JournalEntry {
    var entity: JournalEntryEntity {
        let entity = JournalEntryEntity(item: self)
        return entity
    }
}
