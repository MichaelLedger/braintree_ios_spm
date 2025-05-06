#!/bin/bash

# Script to manually update the Braintree XCFramework in this SPM package
# Usage: ./update-framework.sh [version]
# If no version is provided, it will use 6.30.0 as default

set -e

BRAINTREE_VERSION=${1:-"6.30.0"}
BRAINTREE_URL="https://github.com/braintree/braintree_ios/releases/download/$BRAINTREE_VERSION/Braintree.xcframework.zip"
XCFRAMEWORK_DIR="./Frameworks"
TEMP_DIR="./temp"
ZIP_DIR="./XCFrameworkZips"

echo "Updating to Braintree SDK version $BRAINTREE_VERSION"

# Create directories if they don't exist
mkdir -p $XCFRAMEWORK_DIR $TEMP_DIR $ZIP_DIR

# Clean existing frameworks
rm -rf $XCFRAMEWORK_DIR/Carthage
rm -f $ZIP_DIR/*.zip
rm -f $ZIP_DIR/checksums.txt

# Download the XCFramework
echo "Downloading from $BRAINTREE_URL"
curl -L $BRAINTREE_URL -o "$TEMP_DIR/Braintree.xcframework.zip"

# Calculate checksum
if [[ "$OSTYPE" == "darwin"* ]]; then
  CHECKSUM=$(shasum -a 256 "$TEMP_DIR/Braintree.xcframework.zip" | awk '{print $1}')
else
  CHECKSUM=$(sha256sum "$TEMP_DIR/Braintree.xcframework.zip" | awk '{print $1}')
fi

echo "Checksum: $CHECKSUM"

# Extract XCFrameworks
echo "Extracting XCFrameworks..."
unzip -q -d $XCFRAMEWORK_DIR "$TEMP_DIR/Braintree.xcframework.zip"

# List of frameworks to zip
FRAMEWORKS=(
    "BraintreeAmericanExpress"
    "BraintreeApplePay"
    "BraintreeCard"
    "BraintreeCore"
    "BraintreeDataCollector"
    "BraintreeLocalPayment"
    "BraintreePayPal"
    "BraintreePayPalMessaging"
    "BraintreePayPalNativeCheckout"
    "BraintreeSEPADirectDebit"
    "BraintreeShopperInsights"
    "BraintreeThreeDSecure"
    "BraintreeVenmo"
)

# Zip each framework and calculate checksum
for framework in "${FRAMEWORKS[@]}"; do
    echo "Zipping $framework.xcframework..."
    
    # Check if the framework exists
    if [ ! -d "$XCFRAMEWORK_DIR/Carthage/Build/$framework.xcframework" ]; then
        echo "Warning: $framework.xcframework not found. Skipping..."
        continue
    fi
    
    # Remove any existing zip
    rm -f "$ZIP_DIR/$framework.xcframework.zip"
    
    # Create the zip
    zip -r -q "$ZIP_DIR/$framework.xcframework.zip" "$XCFRAMEWORK_DIR/Carthage/Build/$framework.xcframework"
    
    # Calculate checksum (SHA-256)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CHECKSUM=$(shasum -a 256 "$ZIP_DIR/$framework.xcframework.zip" | awk '{print $1}')
    else
        CHECKSUM=$(sha256sum "$ZIP_DIR/$framework.xcframework.zip" | awk '{print $1}')
    fi
    
    echo "$framework.xcframework.zip checksum: $CHECKSUM"
    echo "$framework.xcframework.zip: $CHECKSUM" >> "$ZIP_DIR/checksums.txt"
done

echo "✅ Successfully updated to Braintree SDK version $BRAINTREE_VERSION"
echo "Now you can commit these changes and create a new release"

# Update package.json
if command -v node &> /dev/null; then
  node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    
    pkg.version = '$BRAINTREE_VERSION';
    if (!pkg.braintree) pkg.braintree = {};
    pkg.braintree.version = '$BRAINTREE_VERSION';
    pkg.braintree.url = '$BRAINTREE_URL';
    pkg.braintree.checksum = '$CHECKSUM';
    
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
  "
else
  echo "Node.js not found. Skipping package.json update."
fi

# Update README
sed -i.bak "s/version [0-9]\+\.[0-9]\+\.[0-9]\+/version $BRAINTREE_VERSION/g" README.md
sed -i.bak "s/from: \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/from: \"$BRAINTREE_VERSION\"/g" README.md
rm README.md.bak 