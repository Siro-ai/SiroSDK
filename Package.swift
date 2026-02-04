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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.4.0/SiroSDK.xcframework.zip",
            checksum: "ea751238bc0d38c67defe480f50ad8a4b3e8335ff33e30cd1118c81f69692d80"
        )
    ]
)
