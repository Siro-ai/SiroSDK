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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.8/SiroSDK.xcframework.zip",
            checksum: "b62c9069d0fce159afa9be51d27171247bb32e992c0c5c861604432023aad7ae"
        )
    ]
) 