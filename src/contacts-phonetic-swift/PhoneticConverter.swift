import Foundation

struct PhoneticConverter {
    struct Configuration {
        let usesJapanese: Bool
        let usesChinese: Bool
        let usesKorean: Bool
        let keepsSpaces: Bool
        let keepsMarks: Bool
    }

    private let configuration: Configuration
    private let multitones: [String: String]

    init(configuration: Configuration, multitones: [String: String]) {
        self.configuration = configuration
        self.multitones = multitones
    }

    func convert(_ source: String) -> String? {
        guard !source.isEmpty else { return nil }

        if source.bestLanguage.hasPrefix("ko") {
            guard configuration.usesKorean else { return nil }
            return normalize(source.latinTranscription)
        }

        let chinese = source.latinTranscription
        guard chinese != source else { return normalize(chinese) }

        let japanese = configuration.usesJapanese ? source.japaneseTranscription : nil
        let enabledChinese = configuration.usesChinese ? chinese : nil
        let alternatives = [japanese, enabledChinese].compactMap(\.nonEmpty)
        guard let first = alternatives.first else { return nil }
        guard alternatives.count == 2, alternatives[0] != alternatives[1] else {
            return normalize(first)
        }
        return normalize(chooseTranscription(
            for: source,
            japanese: alternatives[0],
            chinese: alternatives[1]
        ))
    }

    private func chooseTranscription(for source: String, japanese: String, chinese: String) -> String {
        print("\u{001B}[36m\(source)\u{001B}[0m 1. Japanese (\(japanese)); 2. Chinese (\(chinese)). ", terminator: "")
        guard SelectionPrompt.read(count: 2) == 1 else { return japanese }

        return source.enumerated().map { index, character in
            chooseTone(for: character, at: index, in: source)
        }.joined(separator: " ")
    }

    private func chooseTone(for character: Character, at index: Int, in source: String) -> String {
        let character = String(character)
        guard let tones = multitones[character]?.split(separator: ",").map(String.init) else {
            return character.latinTranscription
        }

        let sourceCharacters = Array(source)
        let before = String(sourceCharacters[..<index])
        let after = String(sourceCharacters[(index + 1)...])
        let choices = tones.enumerated()
            .map { "\($0.offset + 1). \($0.element)" }
            .joined(separator: "; ")
        print("\(before)\u{001B}[36m\(character)\u{001B}[0m\(after) \(choices). ", terminator: "")
        return tones[SelectionPrompt.read(count: tones.count)]
    }

    private func normalize(_ transcription: String) -> String {
        var result = transcription
        if !configuration.keepsMarks { result = result.withoutCombiningMarks }
        if !configuration.keepsSpaces { result = result.replacingOccurrences(of: " ", with: "") }
        return result.capitalized
    }
}

private extension Optional where Wrapped == String {
    var nonEmpty: String? {
        flatMap { $0.isEmpty ? nil : $0 }
    }
}
