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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.7/SiroSDK.xcframework.zip",
            checksum: "d7ed70de0587dcfc19e46f946b897e2a956fb86e2936a5b99bb4fa1e02d8c0dd"
        )
    ]
) 