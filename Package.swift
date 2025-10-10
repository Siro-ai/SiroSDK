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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.0/SiroSDK.xcframework.zip",
            checksum: "7c56d39f16b2139d69b63ceca4794ecdc20b1ce9ec91e0f2058a0fbd705f0a6f"
        )
    ]
) 