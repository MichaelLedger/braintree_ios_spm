#!/bin/bash

# Script to manually update the Braintree XCFramework in this SPM package
# Usage: ./update-framework.sh [version]
# If no version is provided, it will use 6.30.0 as default

set -e

BRAINTREE_VERSION=${1:-"6.30.0"}
BRAINTREE_URL="https://github.com/braintree/braintree_ios/releases/download/$BRAINTREE_VERSION/Braintree.xcframework.zip"
XCFRAMEWORK_DIR="./Frameworks"
TEMP_DIR="./temp"

echo "Updating to Braintree SDK version $BRAINTREE_VERSION"

# Create directories if they don't exist
mkdir -p $XCFRAMEWORK_DIR $TEMP_DIR

# Clean existing frameworks
rm -rf $XCFRAMEWORK_DIR/*.xcframework

# Download the XCFramework
echo "Downloading from $BRAINTREE_URL"
curl -L $BRAINTREE_URL -o "$TEMP_DIR/Braintree.xcframework.zip"

# Calculate checksum
if [[ "$OSTYPE" == "darwin"* ]]; then
  CHECKSUM=$(shasum -a 256 "$TEMP_DIR/Braintree.xcframework.zip" | cut -d' ' -f1)
else
  CHECKSUM=$(sha256sum "$TEMP_DIR/Braintree.xcframework.zip" | cut -d' ' -f1)
fi

echo "Checksum: $CHECKSUM"

# Extract all XCFrameworks from the downloaded zip
echo "Extracting XCFrameworks..."
unzip -q "$TEMP_DIR/Braintree.xcframework.zip" -d "$TEMP_DIR"

# Copy all XCFrameworks to the Frameworks directory
echo "Copying XCFrameworks to $XCFRAMEWORK_DIR..."
find "$TEMP_DIR/Carthage/Build" -name "*.xcframework" -type d -exec cp -R {} $XCFRAMEWORK_DIR/ \;

# Clean up temporary files
rm -rf $TEMP_DIR

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

echo "✅ Successfully updated to Braintree SDK version $BRAINTREE_VERSION"
echo "Now you can commit these changes and create a new release" 