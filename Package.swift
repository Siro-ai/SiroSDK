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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.1.0/SiroSDK.xcframework.zip",
            checksum: "6b27b9de07b734aa82939b6fba42ea704ef08e488458d3355ed38079190b205b"
        )
    ]
) 