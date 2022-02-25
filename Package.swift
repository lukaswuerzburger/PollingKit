// swift-tools-version:5.0
//
// PaginationController
//

import PackageDescription

let package = Package(
    name: "PollingKit",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "PollingKit",
            targets: ["PollingKit"]
        )
    ],
    targets: [
        .target(
            name: "PollingKit",
            path: "PollingKit"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
