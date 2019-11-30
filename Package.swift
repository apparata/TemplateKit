// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TemplateKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        .library(
            name: "TemplateKit",
            targets: ["TemplateKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TemplateKit",
            dependencies: []),
        .testTarget(
            name: "TemplateKitTests",
            dependencies: ["TemplateKit"]),
    ]
)
