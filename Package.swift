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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.1.3/SiroSDK.xcframework.zip",
            checksum: "b3c3e819764f69a9439287e0a52e25ac2a01a8b3c3392241c43c02d8cb142003"
        )
    ]
) 