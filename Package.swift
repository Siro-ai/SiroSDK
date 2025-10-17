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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.3/SiroSDK.xcframework.zip",
            checksum: "79c945470a3c50bc0713ecb41f7ce00ea498432d87550cba7001d6de9b919c88"
        )
    ]
) 