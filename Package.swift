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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.6.2/SiroSDK.xcframework.zip",
            checksum: "5ad5a7b861a69264595efae4b8fa42f010aa454b76e2ae1f71e5f16b2d578079"
        )
    ]
)
