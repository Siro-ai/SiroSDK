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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.6.1/SiroSDK.xcframework.zip",
            checksum: "fe787f58aed947ea257bc04fdfeee091c6dfd1fb33b9d282b499ce2b0b068525"
        )
    ]
)
