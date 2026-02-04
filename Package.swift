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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.4.1/SiroSDK.xcframework.zip",
            checksum: "b4e7a2782e4b60f2f49fa34cdf5e0456947783b2a78da660e7506fd283da6ecf"
        )
    ]
)
