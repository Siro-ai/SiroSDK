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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.10/SiroSDK.xcframework.zip",
            checksum: "6712a19a253977a2294c8b3234b19ac279a0505a33dbc1ff2c1e56c768cdd36a"
        )
    ]
) 