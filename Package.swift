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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.5/SiroSDK.xcframework.zip",
            checksum: "ad21d6822f4786f20d109ffe930a4409c460b0f6dc83b684ebd34bb5c0437091"
        )
    ]
) 