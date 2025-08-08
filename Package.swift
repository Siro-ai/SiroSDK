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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.1.1/SiroSDK.xcframework.zip",
            checksum: "3b64406b846d6ba306e30d6f67dadc2c66332e40e4bb87e653838ee83d8a5a9e"
        )
    ]
) 