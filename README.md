# Braintree iOS SPM

Swift Package Manager distribution for Braintree iOS SDK version 6.30.0.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/braintree_ios_spm.git", from: "6.30.0")
]
```

Then add the specific Braintree modules you need to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "BraintreeCore", package: "braintree_ios_spm"),
            .product(name: "BraintreeCard", package: "braintree_ios_spm"),
            .product(name: "BraintreePayPal", package: "braintree_ios_spm")
            // Add other modules as needed
        ]
    )
]
```

## Available Modules

This package provides the following Braintree modules:

- BraintreeCore - Core functionality required by all other modules
- BraintreeAmericanExpress - American Express payments
- BraintreeApplePay - Apple Pay integration
- BraintreeCard - Credit and debit card payments
- BraintreeDataCollector - Fraud detection tools
- BraintreeLocalPayment - Local payment methods
- BraintreePayPal - PayPal payments
- BraintreePayPalMessaging - PayPal messaging components
- BraintreePayPalNativeCheckout - Native PayPal checkout experience
- BraintreeSEPADirectDebit - SEPA direct debit payments
- BraintreeShopperInsights - Shopper data collection
- BraintreeThreeDSecure - 3D Secure authentication
- BraintreeVenmo - Venmo payments

## How it Works

This repository automatically downloads the official Braintree iOS SDK XCFramework from the official Braintree repository and creates a Swift Package Manager compatible package.

The GitHub Action workflow runs whenever a new release is published, downloading the specified version of the Braintree XCFramework, calculating its checksum, and updating the Package.swift file.

## Documentation

For documentation and usage instructions, see the [official Braintree documentation](https://developer.paypal.com/braintree/docs/start/hello-client/ios/v5). 