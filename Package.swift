// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BundledDocumentationRenderer",
    platforms: [.macOS(.v15), .iOS(.v18), .visionOS(.v2)],
    products: [
        .library(
            name: "BundledDocumentationRenderer",
            targets: ["BundledDocumentationRenderer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/docsyco/DocumentationKit", branch: "main"),
    ],
    targets: [
        .target(
            name: "BundledDocumentationRenderer",
            dependencies: [.product(name: "DocumentationRenderer", package: "DocumentationKit")],
            resources: [.copy("BundledResources")]
        ),
    ]
)
