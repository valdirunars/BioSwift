// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "BioSwift",
    dependencies: [
        .Package(url: "https://github.com/attaswift/BigInt.git", majorVersion: 3, minorVersion: 0)
    ]
)
