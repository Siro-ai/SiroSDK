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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.1/SiroSDK.xcframework.zip",
            checksum: "fd05f9bd2b9dbc2214c90c49e15309f77cf5faf81d5af5a1ae0d43d2c42a10d4"
        )
    ]
) 