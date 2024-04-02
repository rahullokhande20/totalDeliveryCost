// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "totalDeliveryCost",
    platforms: [.macOS(.v12)],
    dependencies: [        
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "totalDeliveryCost",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
    ]
)
