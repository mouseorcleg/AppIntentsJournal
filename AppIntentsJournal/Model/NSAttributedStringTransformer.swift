/*
See LICENSE folder for this sample’s licensing information.

Abstract: A transformer used to store NSAttributedStrings in the data store.

*/

import Foundation

@objc(NSAttributedStringTransformer)
class NSAttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }

    override class func transformedValueClass() -> AnyClass {
        return NSAttributedString.self
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let attributedString = value as? NSAttributedString else {
            return nil
        }
        return attributedString.toNSData()
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {
            return nil
        }
        return data.toAttributedString()
    }
}

private extension NSData {
    func toAttributedString() -> NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtf,
            .characterEncoding: String.Encoding.utf8
        ]
        return try? NSAttributedString(data: Data(referencing: self),
                                       options: options,
                                       documentAttributes: nil)
    }
}

private extension NSAttributedString {
    func toNSData() -> NSData? {
        let options: [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtf,
            .characterEncoding: String.Encoding.utf8
        ]
        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range, documentAttributes: options) else {
            return nil
        }
        return NSData(data: data)
    }
}

extension NSValueTransformerName {
    static let nsAttributedStringTransformer = NSValueTransformerName(rawValue: "NSAttributedStringTransformer")
}
