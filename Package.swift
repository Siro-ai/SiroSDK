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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.13/SiroSDK.xcframework.zip",
            checksum: "87793ef81b66e57b3b369bc7d648c00365f92fee9a5b7c01261f3addb2b8c9ef"
        )
    ]
) 