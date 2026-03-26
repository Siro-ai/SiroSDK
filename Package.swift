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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.6.0/SiroSDK.xcframework.zip",
            checksum: "59b1b430fcaa0707469a5a4933674cb9d45ac72494e979e81ec67025afb47921"
        )
    ]
)
