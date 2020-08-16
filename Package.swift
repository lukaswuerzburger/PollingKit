// swift-tools-version:5.0
//
// PaginationController
//

import PackageDescription

let package = Package(
    name: "PollingController",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "PollingController",
            targets: ["PollingController"]
        )
    ],
    targets: [
        .target(
            name: "PollingController",
            path: "PollingController"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
