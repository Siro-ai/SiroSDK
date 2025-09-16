// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SiroSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SiroSDK",
            targets: ["SiroSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SiroSDK",
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.2.0/SiroSDK.xcframework.zip",
            checksum: "001b1a07dadc942e15c751afd37022d1f1826c70d64c86353afc5aec503e3b52"
        )
    ]
) 