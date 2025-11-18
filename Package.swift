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
            url: "https://github.com/Siro-ai/SiroSDK/releases/download/2.3.9/SiroSDK.xcframework.zip",
            checksum: "fd5e1ac597854a6ae80febda98c49e621753328419d05d6a52287eafa42293a3"
        )
    ]
) 