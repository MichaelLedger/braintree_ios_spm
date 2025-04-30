// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BraintreeSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "BraintreeSDK",
            targets: ["BraintreeSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "BraintreeSDK",
            url: "https://github.com/braintree/braintree_ios/releases/download/6.30.0/Braintree.xcframework.zip",
            checksum: "8957c69abebdec7c9a35e1bd72110775899f527d912320169cb319ee3c7971a1"
        ),
    ]
) 