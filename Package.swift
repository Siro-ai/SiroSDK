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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.6.3/SiroSDK.xcframework.zip",
            checksum: "f87e39b6ed6dfabce1045a9c4f912f985cecae0dba51aeb07d94b419fc7b1035"
        )
    ]
)
