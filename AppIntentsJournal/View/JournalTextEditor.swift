/*
See LICENSE folder for this sample’s licensing information.

Abstract: A view that manages a UITextView.

*/

import SwiftUI

struct JournalTextEditor: UIViewRepresentable {
    
    @Binding var text: NSAttributedString
    @Binding var sidePadding: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = JournalTextView()
        textView.isEditable = true
        textView.allowsEditingTextAttributes = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
        sidePadding = uiView.textContainer.lineFragmentPadding
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(textEditor: self)
    }
}

class Coordinator: NSObject, UITextViewDelegate {
    var textEditor: JournalTextEditor
    
    init(textEditor: JournalTextEditor) {
        self.textEditor = textEditor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textEditor.text = textView.attributedText
    }
}

class JournalTextView: UITextView {
    func monospacedRanges(in enclosingRange: NSRange) -> [NSRange] {
        var ranges: [NSRange] = []
        attributedText.enumerateAttribute(.font, in: enclosingRange) { value, range, _ in
            guard let font = value as? UIFont, font.fontDescriptor.symbolicTraits.contains(.traitMonoSpace) else { return }
            ranges.append(range)
        }
        return ranges
    }
}
