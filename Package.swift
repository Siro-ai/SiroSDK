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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.5.1/SiroSDK.xcframework.zip",
            checksum: "9f8f156f1515a7aaa71cdbb4628a0cf8f80913d281ceadb243e6de5d2c5b2b9f"
        )
    ]
)
