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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.0.1/SiroSDK.xcframework.zip",
            checksum: "a4329cb7b1f14b8f853406e09b3aea97f7de04adfe3bf990fc6783c561660565"
        )
    ]
) 