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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.4/SiroSDK.xcframework.zip",
            checksum: "3db695b7a38c3e6d91b163fb656bf159116ad4c48375cea1502ea0982c44d345"
        )
    ]
) 