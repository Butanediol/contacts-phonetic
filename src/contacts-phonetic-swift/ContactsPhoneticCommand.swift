import ArgumentParser
import Multitones

private let version = "contacts-phonetic version 0.3 Copyright (c) 2016 Elethom Hunter, 2026 Butanediol"

@main
struct ContactsPhoneticCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "contacts-phonetic",
        abstract: "Add phonetic names to contacts.",
        version: version
    )

    @Flag(name: [.customShort("j"), .long], help: "Ignore Japanese. Use Chinese Pinyin when both are possible.")
    private var ignoreJapanese = false

    @Flag(name: [.customShort("k"), .long], help: "Ignore Korean.")
    private var ignoreKorean = false

    @Flag(name: [.customShort("c"), .long], help: "Ignore Chinese. Use Japanese Romaji when both are possible.")
    private var ignoreChinese = false

    @Flag(name: [.customShort("s"), .long], help: "Keep spaces between characters.")
    private var keepSpaces = false

    @Flag(name: [.customShort("m"), .customLong("keep-marks")], help: "Keep accents and diacritics.")
    private var keepMarks = false

    @Flag(name: [.customShort("i"), .long], help: "Overwrite existing phonetic names.")
    private var overwriteExisting = false

    @Flag(name: .customLong("ignore-existing"), help: "Deprecated alias for --overwrite-existing.")
    private var ignoreExisting = false

    @Flag(name: .customShort("v"), help: .hidden)
    private var shortVersion = false

    mutating func run() throws {
        guard !shortVersion else {
            print(version)
            return
        }

        let converter = PhoneticConverter(
            configuration: .init(
                usesJapanese: !ignoreJapanese,
                usesChinese: !ignoreChinese,
                usesKorean: !ignoreKorean,
                keepsSpaces: keepSpaces,
                keepsMarks: keepMarks
            ),
            multitones: ContactsPhoneticMultitones()
        )
        let updater = AddressBookUpdater(
            converter: converter,
            overwritesExisting: overwriteExisting || ignoreExisting
        )
        updater.run()
    }
}
