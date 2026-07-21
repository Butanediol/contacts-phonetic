// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "contacts-phonetic",
    products: [
        .executable(
            name: "contacts-phonetic",
            targets: ["contacts-phonetic-swift"]
        ),
        .executable(
            name: "contacts-phonetic-objc",
            targets: ["contacts-phonetic-objc"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.8.2"
        ),
    ],
    targets: [
        .executableTarget(
            name: "contacts-phonetic-swift",
            dependencies: [
                "Multitones",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
            ],
            path: "src/contacts-phonetic-swift",
            linkerSettings: [
                .linkedFramework("AddressBook"),
            ]
        ),
        .executableTarget(
            name: "contacts-phonetic-objc",
            dependencies: ["Multitones"],
            path: "src/contacts-phonetic-objc",
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("AddressBook"),
            ]
        ),
        .target(
            name: "Multitones",
            path: "src/Multitones",
            publicHeadersPath: "include"
        ),
    ],
    swiftLanguageModes: [.v6]
)
