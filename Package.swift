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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.6/SiroSDK.xcframework.zip",
            checksum: "7167a089a1a9de342d49acc921c04db7ff123226b0e86c7aacb543c235a282fc"
        )
    ]
) 