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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.5.2/SiroSDK.xcframework.zip",
            checksum: "fa0de468ead881d0c5dcdf91446438d652f4e6e6b1a96c3507956a20d65a7d62"
        )
    ]
)
