# Braintree iOS SPM

Swift Package Manager distribution for Braintree iOS SDK version 6.30.0.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/braintree_ios_spm.git", from: "6.30.0")
]
```

## How it Works

This repository automatically downloads the official Braintree iOS SDK XCFramework from the official Braintree repository and creates a Swift Package Manager compatible package.

The GitHub Action workflow runs whenever a new release is published, downloading the specified version of the Braintree XCFramework, calculating its checksum, and updating the Package.swift file.

## Documentation

For documentation and usage instructions, see the [official Braintree documentation](https://developer.paypal.com/braintree/docs/start/hello-client/ios/v5). 