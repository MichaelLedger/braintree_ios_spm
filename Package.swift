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
            targets: ["BraintreePayPalMessaging"]
        ),
        .library(
            name: "BraintreePayPalNativeCheckout",
            targets: ["BraintreePayPalNativeCheckout"]
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
                "PPRiskMagnes"
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
        )
    ]
) 