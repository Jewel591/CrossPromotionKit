// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CrossPromotionKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "CrossPromotionKit", targets: ["CrossPromotionKit"]),
    ],
    targets: [
        .target(
            name: "CrossPromotionKit",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "CrossPromotionKitTests",
            dependencies: ["CrossPromotionKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

