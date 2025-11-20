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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.12/SiroSDK.xcframework.zip",
            checksum: "c70315d7707a986709c5d4cbd1b95267975f5ee41f0fecff043db70396b472a0"
        )
    ]
) 