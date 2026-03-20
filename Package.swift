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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.5.0/SiroSDK.xcframework.zip",
            checksum: "96d8c299cf5dbdf44a0402e9ce733b04b50d3c807666eac479794db274dbb412"
        )
    ]
)
