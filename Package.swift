// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pokemon",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Pokemon",
            targets: ["Pokemon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-cocoa.git", from: "10.50.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "Pokemon",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-cocoa"),
                "SnapKit"
            ]),
        .testTarget(
            name: "PokemonTests",
            dependencies: ["Pokemon"]),
    ]
)

