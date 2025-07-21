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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.0.5/SiroSDK.xcframework.zip",
            checksum: "39c2f9fd56758b3eb678b01a82c17c75cd7a1bfe00f795f77d47cddbc67a03c5"
        )
    ]
) 