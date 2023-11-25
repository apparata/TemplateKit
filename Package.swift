// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "TemplateKit",
    platforms: [
        .macOS(.v13), .iOS(.v13)
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
