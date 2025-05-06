// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Braintree",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "BraintreeAmericanExpress",
            targets: ["BraintreeAmericanExpress"]
        ),
        .library(
            name: "BraintreeApplePay",
            targets: ["BraintreeApplePay"]
        ),
        .library(
            name: "BraintreeCard",
            targets: ["BraintreeCard"]
        ),
        .library(
            name: "BraintreeCore",
            targets: ["BraintreeCore"]
        ),
        .library(
            name: "BraintreeDataCollector",
            targets: ["BraintreeDataCollector", "PPRiskMagnes"]
        ),
        .library(
            name: "BraintreeLocalPayment",
            targets: ["BraintreeLocalPayment", "PPRiskMagnes"]
        ),
        .library(
            name: "BraintreePayPal",
            targets: ["BraintreePayPal", "PPRiskMagnes"]
        ),
        .library(
            name: "BraintreePayPalMessaging",
            targets: ["BraintreePayPalMessaging", "PayPalMessages"]
        ),
        .library(
            name: "BraintreePayPalNativeCheckout",
            targets: ["BraintreePayPalNativeCheckout", "PayPalCheckout"]
        ),
        .library(
            name: "BraintreeSEPADirectDebit",
            targets: ["BraintreeSEPADirectDebit"]
        ),
        .library(
            name: "BraintreeShopperInsights",
            targets: ["BraintreeShopperInsights"]
        ),
        .library(
            name: "BraintreeThreeDSecure",
            targets: ["BraintreeThreeDSecure", "CardinalMobile", "PPRiskMagnes"]
        ),
        .library(
            name: "BraintreeVenmo",
            targets: ["BraintreeVenmo"]
        ),
        // Complete SDK
        .library(
            name: "Braintree", 
            targets: [
                "BraintreeCore",
                "BraintreeCard",
                "BraintreePayPal",
                "BraintreeApplePay",
                "BraintreeDataCollector",
                "BraintreeThreeDSecure",
                "BraintreeVenmo",
                "BraintreeLocalPayment",
                "BraintreeAmericanExpress",
                "BraintreePayPalMessaging",
                "BraintreePayPalNativeCheckout",
                "BraintreeSEPADirectDebit",
                "BraintreeShopperInsights",
                "CardinalMobile",
                "PPRiskMagnes",
                "PayPalMessages",
                "PayPalCheckout"
            ]
        ),
        // Required additional modules
        .library(
            name: "CardinalMobile",
            targets: ["CardinalMobile"]
        ),
        .library(
            name: "PPRiskMagnes",
            targets: ["PPRiskMagnes"]
        ),
        .library(
            name: "PayPalMessages",
            targets: ["PayPalMessages"]
        ),
        .library(
            name: "PayPalCheckout",
            targets: ["PayPalCheckout"]
        )
    ],
    dependencies: [],
    targets: [
        // All binary targets pointing to individual XCFramework zips
        .binaryTarget(
            name: "BraintreeCore",
            path: "XCFrameworkZips/BraintreeCore.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeCard",
            path: "XCFrameworkZips/BraintreeCard.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeAmericanExpress",
            path: "XCFrameworkZips/BraintreeAmericanExpress.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeApplePay",
            path: "XCFrameworkZips/BraintreeApplePay.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeDataCollector",
            path: "XCFrameworkZips/BraintreeDataCollector.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeLocalPayment",
            path: "XCFrameworkZips/BraintreeLocalPayment.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreePayPal",
            path: "XCFrameworkZips/BraintreePayPal.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreePayPalMessaging",
            path: "XCFrameworkZips/BraintreePayPalMessaging.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreePayPalNativeCheckout",
            path: "XCFrameworkZips/BraintreePayPalNativeCheckout.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeSEPADirectDebit",
            path: "XCFrameworkZips/BraintreeSEPADirectDebit.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeShopperInsights",
            path: "XCFrameworkZips/BraintreeShopperInsights.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeThreeDSecure",
            path: "XCFrameworkZips/BraintreeThreeDSecure.xcframework.zip"
        ),
        .binaryTarget(
            name: "BraintreeVenmo",
            path: "XCFrameworkZips/BraintreeVenmo.xcframework.zip"
        ),
        // Required additional binary targets
        .binaryTarget(
            name: "CardinalMobile",
            path: "XCFrameworkZips/CardinalMobile.xcframework.zip"
        ),
        .binaryTarget(
            name: "PPRiskMagnes",
            path: "XCFrameworkZips/PPRiskMagnes.xcframework.zip"
        ),
        // PayPal dependencies
        .binaryTarget(
            name: "PayPalMessages",
            url: "https://github.com/paypal/paypal-messages-ios/releases/download/1.0.0/PayPalMessages.xcframework.zip",
            checksum: "565ab72a3ab75169e41685b16e43268a39e24217a12a641155961d8b10ffe1b4"
        ),
        .binaryTarget(
            name: "PayPalCheckout",
            url: "https://github.com/paypal/paypalcheckout-ios/releases/download/1.3.0/PayPalCheckout.xcframework.zip",
            checksum: "d65186f38f390cb9ae0431ecacf726774f7f89f5474c48244a07d17b248aa035"
        )
    ]
) 