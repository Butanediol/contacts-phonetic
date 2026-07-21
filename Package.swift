// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "contacts-phonetic",
    products: [
        .executable(
            name: "contacts-phonetic",
            targets: ["contacts-phonetic"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "contacts-phonetic",
            path: "src/contacts-phonetic",
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("AddressBook"),
            ]
        ),
    ]
)
