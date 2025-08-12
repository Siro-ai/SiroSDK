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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.1.2/SiroSDK.xcframework.zip",
            checksum: "bbd46a0ec8a4782b15bc5280b88f7a44f40e8231bcc5748766bc1b8bb2451899"
        )
    ]
) 