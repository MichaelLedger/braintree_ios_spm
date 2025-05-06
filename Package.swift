// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Braintree",
    platforms: [
        .iOS(.v14)
    ],
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
            targets: ["BraintreeDataCollector"]
        ),
        .library(
            name: "BraintreeLocalPayment",
            targets: ["BraintreeLocalPayment"]
        ),
        .library(
            name: "BraintreePayPal",
            targets: ["BraintreePayPal"]
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
            targets: ["BraintreeThreeDSecure"]
        ),
        .library(
            name: "BraintreeVenmo",
            targets: ["BraintreeVenmo"]
        ),
        .library(
            name: "CardinalMobile",
            targets: ["CardinalMobile"]
        ),
        .library(
            name: "PPRiskMagnes",
            targets: ["PPRiskMagnes"]
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
                "BraintreeShopperInsights"
            ]
        )
    ],
    dependencies: [],
    targets: [
        // All targets extract from a single XCFramework archive
        .binaryTarget(
            name: "BraintreeCore",
            path: "Frameworks/BraintreeCore.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeCard",
            path: "Frameworks/BraintreeCard.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeAmericanExpress",
            path: "Frameworks/BraintreeAmericanExpress.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeApplePay",
            path: "Frameworks/BraintreeApplePay.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeDataCollector",
            path: "Frameworks/BraintreeDataCollector.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeLocalPayment",
            path: "Frameworks/BraintreeLocalPayment.xcframework"
        ),
        .binaryTarget(
            name: "BraintreePayPal",
            path: "Frameworks/BraintreePayPal.xcframework"
        ),
        .binaryTarget(
            name: "BraintreePayPalMessaging",
            path: "Frameworks/BraintreePayPalMessaging.xcframework"
        ),
        .binaryTarget(
            name: "BraintreePayPalNativeCheckout",
            path: "Frameworks/BraintreePayPalNativeCheckout.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeSEPADirectDebit",
            path: "Frameworks/BraintreeSEPADirectDebit.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeShopperInsights",
            path: "Frameworks/BraintreeShopperInsights.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeThreeDSecure",
            path: "Frameworks/BraintreeThreeDSecure.xcframework"
        ),
        .binaryTarget(
            name: "BraintreeVenmo",
            path: "Frameworks/BraintreeVenmo.xcframework"
        ),
        .binaryTarget(
            name: "CardinalMobile",
            path: "Frameworks/CardinalMobile.xcframework"
        ),
        .binaryTarget(
            name: "PPRiskMagnes",
            path: "Frameworks/PPRiskMagnes.xcframework"
        )
    ]
) 