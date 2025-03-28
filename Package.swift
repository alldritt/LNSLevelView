// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LNSLevelView",
    platforms: [
        .macOS(.v13), .iOS(.v16), .tvOS(.v13), .watchOS(.v7)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LNSLevelView",
            targets: ["LNSLevelView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alldritt/LNSSwiftUIExtras.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LNSLevelView",
            dependencies: [
                "LNSSwiftUIExtras"
            ]
        )
    ]
)
