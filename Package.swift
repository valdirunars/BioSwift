// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BioSwift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "BioSwift",
            targets: ["BioSwift"]),
    ],
    dependencies: [
        .package(url: "http://github.com/valdirunars/BigIntCompress.git", from: "1.0.0"),
        .package(url: "http://github.com/attaswift/BigInt.git", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BioSwift",
            dependencies: [ "BigInt", "BigIntCompress" ],
	    path: ".",
            sources: ["Sources"]),
        .testTarget(
            name: "BioSwiftTests",
            dependencies: ["BioSwift"]),
    ]
)
