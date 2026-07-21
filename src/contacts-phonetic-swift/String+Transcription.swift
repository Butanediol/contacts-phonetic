import CoreFoundation
import Foundation

extension String {
    var bestLanguage: String {
        CFStringTokenizerCopyBestStringLanguage(
            self as CFString,
            CFRange(location: 0, length: utf16.count)
        ) as String? ?? ""
    }

    var latinTranscription: String {
        applyingTransform(.toLatin, reverse: false) ?? self
    }

    var japaneseTranscription: String {
        let result = NSMutableString()
        let tokenizer = CFStringTokenizerCreate(
            kCFAllocatorDefault,
            self as CFString,
            CFRange(location: 0, length: utf16.count),
            CFOptionFlags(kCFStringTokenizerUnitWord),
            Locale(identifier: "ja") as CFLocale
        )

        while CFStringTokenizerAdvanceToNextToken(tokenizer).rawValue != 0 {
            guard let value = CFStringTokenizerCopyCurrentTokenAttribute(
                tokenizer,
                CFOptionFlags(kCFStringTokenizerAttributeLatinTranscription)
            ) as? String else { continue }
            result.append(value)
        }
        return result as String
    }

    var withoutCombiningMarks: String {
        applyingTransform(.stripCombiningMarks, reverse: false) ?? self
    }
}
