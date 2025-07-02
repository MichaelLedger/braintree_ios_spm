#!/bin/bash

# Script to manually update the Braintree XCFramework in this SPM package
# Usage: ./update-framework.sh [version] [--force]
# If no version is provided, it will fetch the latest release version
# Use --force to regenerate zips even if the version hasn't changed

set -e

# Function to fetch latest release version
fetch_latest_version() {
    local api_url="https://api.github.com/repos/braintree/braintree_ios/releases/latest"
    local latest_version
    
    if command -v curl &> /dev/null; then
        latest_version=$(curl -s "$api_url" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    elif command -v wget &> /dev/null; then
        latest_version=$(wget -qO- "$api_url" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    else
        echo "Error: Neither curl nor wget found. Please install one of them or specify version manually."
        exit 1
    fi
    
    if [ -z "$latest_version" ]; then
        echo "Error: Failed to fetch latest version. Please specify version manually."
        exit 1
    fi
    
    echo "$latest_version"
}

# Get version from argument or fetch latest
if [ -n "$1" ] && [ "$1" != "--force" ]; then
    BRAINTREE_VERSION="$1"
else
    echo "No version specified. Fetching latest release version..."
    BRAINTREE_VERSION=$(fetch_latest_version)
    echo "Latest version: $BRAINTREE_VERSION"
fi

FORCE_REGENERATE=false
if [ "$2" = "--force" ] || [ "$1" = "--force" ]; then
    FORCE_REGENERATE=true
fi

BRAINTREE_URL="https://github.com/braintree/braintree_ios/releases/download/$BRAINTREE_VERSION/Braintree.xcframework.zip"
XCFRAMEWORK_DIR="./Frameworks"
TEMP_DIR="./temp"
ZIP_DIR="./XCFrameworkZips"

echo "Requested Braintree SDK version: $BRAINTREE_VERSION"

# Create directories if they don't exist
mkdir -p $XCFRAMEWORK_DIR $TEMP_DIR $ZIP_DIR

# Check if version has changed
CURRENT_VERSION=""
VERSION_CHANGED=false
if [ -f "package.json" ]; then
    if command -v node &> /dev/null; then
        CURRENT_VERSION=$(node -e "try { const pkg = require('./package.json'); console.log(pkg.braintree?.version || ''); } catch(e) { console.log(''); }")
    else
        # Fallback to grep if node is not available
        CURRENT_VERSION=$(grep -o '"version": "[^"]*"' package.json | head -1 | cut -d'"' -f4)
    fi
fi

if [ "$CURRENT_VERSION" != "$BRAINTREE_VERSION" ]; then
    VERSION_CHANGED=true
fi

# External PayPal frameworks
PAYPAL_MESSAGES_VERSION="1.0.0"
PAYPAL_MESSAGES_URL="https://github.com/paypal/paypal-messages-ios/releases/download/$PAYPAL_MESSAGES_VERSION/PayPalMessages.xcframework.zip"
PAYPAL_MESSAGES_CHECKSUM="565ab72a3ab75169e41685b16e43268a39e24217a12a641155961d8b10ffe1b4"

PAYPAL_CHECKOUT_VERSION="1.3.0"
PAYPAL_CHECKOUT_URL="https://github.com/paypal/paypalcheckout-ios/releases/download/$PAYPAL_CHECKOUT_VERSION/PayPalCheckout.xcframework.zip"
PAYPAL_CHECKOUT_CHECKSUM="d65186f38f390cb9ae0431ecacf726774f7f89f5474c48244a07d17b248aa035"

# Get existing checksums from package.json if version hasn't changed and not forcing regeneration
NEED_REGENERATE=true
EXISTING_CHECKSUMS_JSON=""

if [ "$VERSION_CHANGED" = false ] && [ "$FORCE_REGENERATE" = false ]; then
    echo "Current version is already $BRAINTREE_VERSION."
    
    # Check if zips exist
    MISSING_ZIPS=false
    for framework in "${FRAMEWORKS[@]}"; do
        if [ ! -f "$ZIP_DIR/$framework.xcframework.zip" ]; then
            MISSING_ZIPS=true
            echo "Missing zip file: $framework.xcframework.zip"
        fi
    done
    
    for framework in "${ADDITIONAL_FRAMEWORKS[@]}"; do
        if [ ! -f "$ZIP_DIR/$framework.xcframework.zip" ]; then
            MISSING_ZIPS=true
            echo "Missing zip file: $framework.xcframework.zip"
        fi
    done
    
    if [ "$MISSING_ZIPS" = true ]; then
        echo "Some framework zips are missing. Will regenerate all zips."
    else
        # Use existing checksums from package.json
        if command -v node &> /dev/null; then
            EXISTING_CHECKSUMS_JSON=$(node -e "try { const pkg = require('./package.json'); console.log(JSON.stringify(pkg.braintree?.frameworks || [])); } catch(e) { console.log('[]'); }")
            MAIN_CHECKSUM=$(node -e "try { const pkg = require('./package.json'); console.log(pkg.braintree?.mainChecksum || ''); } catch(e) { console.log(''); }")
            
            # Check if we have valid existing checksums
            if [ "$EXISTING_CHECKSUMS_JSON" != "[]" ] && [ -n "$MAIN_CHECKSUM" ]; then
                NEED_REGENERATE=false
                echo "Using existing framework zips and checksums."
            fi
        fi
    fi
fi

# List of frameworks to zip from Carthage/Build
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

# Additional frameworks from XCFrameworks directory
ADDITIONAL_FRAMEWORKS=(
    "CardinalMobile"
    "PPRiskMagnes"
)

# If we need to regenerate, download and extract the frameworks
if [ "$NEED_REGENERATE" = true ] || [ "$FORCE_REGENERATE" = true ]; then
    echo "Will regenerate framework zips."
    
    # Clean existing frameworks
    echo "Cleaning existing frameworks..."
    rm -rf $XCFRAMEWORK_DIR/Carthage
    rm -f $ZIP_DIR/*.zip
    rm -f $ZIP_DIR/checksums.txt
    
    # Download the XCFramework
    echo "Downloading from $BRAINTREE_URL"
    curl -L $BRAINTREE_URL -o "$TEMP_DIR/Braintree.xcframework.zip"
    
    # Calculate checksum of the main framework zip
    if [[ "$OSTYPE" == "darwin"* ]]; then
      MAIN_CHECKSUM=$(shasum -a 256 "$TEMP_DIR/Braintree.xcframework.zip" | awk '{print $1}')
    else
      MAIN_CHECKSUM=$(sha256sum "$TEMP_DIR/Braintree.xcframework.zip" | awk '{print $1}')
    fi
    
    echo "Main Checksum: $MAIN_CHECKSUM"
    
    # Extract XCFrameworks
    echo "Extracting XCFrameworks..."
    unzip -q -d $XCFRAMEWORK_DIR "$TEMP_DIR/Braintree.xcframework.zip"
    
    # Initialize empty JSON array for checksums
    CHECKSUMS_JSON="["
    
    # Zip each framework from Carthage/Build and calculate checksum
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
        
        # Add to JSON array
        CHECKSUMS_JSON+="{ \"name\": \"$framework\", \"checksum\": \"$CHECKSUM\" },"
    done
    
    # Zip each additional framework from XCFrameworks directory
    for framework in "${ADDITIONAL_FRAMEWORKS[@]}"; do
        echo "Zipping $framework.xcframework..."
        
        # Check if the framework exists
        if [ ! -d "$XCFRAMEWORK_DIR/XCFrameworks/$framework.xcframework" ]; then
            echo "Warning: $XCFRAMEWORK_DIR/XCFrameworks/$framework.xcframework not found. Skipping..."
            continue
        fi
        
        # Remove any existing zip
        rm -f "$ZIP_DIR/$framework.xcframework.zip"
        
        # Create the zip
        zip -r -q "$ZIP_DIR/$framework.xcframework.zip" "$XCFRAMEWORK_DIR/XCFrameworks/$framework.xcframework"
        
        # Calculate checksum (SHA-256)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            CHECKSUM=$(shasum -a 256 "$ZIP_DIR/$framework.xcframework.zip" | awk '{print $1}')
        else
            CHECKSUM=$(sha256sum "$ZIP_DIR/$framework.xcframework.zip" | awk '{print $1}')
        fi
        
        echo "$framework.xcframework.zip checksum: $CHECKSUM"
        echo "$framework.xcframework.zip: $CHECKSUM" >> "$ZIP_DIR/checksums.txt"
        
        # Add to JSON array
        CHECKSUMS_JSON+="{ \"name\": \"$framework\", \"checksum\": \"$CHECKSUM\" },"
    done
    
    # Add PayPal external frameworks to JSON array
    CHECKSUMS_JSON+="{ \"name\": \"PayPalMessages\", \"checksum\": \"$PAYPAL_MESSAGES_CHECKSUM\", \"url\": \"$PAYPAL_MESSAGES_URL\", \"version\": \"$PAYPAL_MESSAGES_VERSION\" },"
    CHECKSUMS_JSON+="{ \"name\": \"PayPalCheckout\", \"checksum\": \"$PAYPAL_CHECKOUT_CHECKSUM\", \"url\": \"$PAYPAL_CHECKOUT_URL\", \"version\": \"$PAYPAL_CHECKOUT_VERSION\" },"
    
    # Remove trailing comma and close the array
    CHECKSUMS_JSON=${CHECKSUMS_JSON%,}
    CHECKSUMS_JSON+="]"
else
    # Use existing checksums
    CHECKSUMS_JSON=$EXISTING_CHECKSUMS_JSON
fi

if [ "$VERSION_CHANGED" = true ] || [ "$FORCE_REGENERATE" = true ] || [ "$NEED_REGENERATE" = true ]; then
    echo "✅ Successfully updated to Braintree SDK version $BRAINTREE_VERSION"
else
    echo "✅ No changes needed for Braintree SDK version $BRAINTREE_VERSION"
fi

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
    pkg.braintree.mainChecksum = '$MAIN_CHECKSUM';
    pkg.braintree.frameworks = $CHECKSUMS_JSON;
    
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
  "
  echo "Updated package.json with framework information"
  
  # Update package-lock.json
  if command -v npm &> /dev/null; then
    echo "Updating package-lock.json..."
    npm install --package-lock-only
    echo "✅ Updated package-lock.json"
  else
    echo "npm not found. Skipping package-lock.json update."
  fi
else
  echo "Node.js not found. Skipping package.json and package-lock.json updates."
fi

# Update README
sed -i.bak "s/version [0-9]\+\.[0-9]\+\.[0-9]\+/version $BRAINTREE_VERSION/g" README.md
sed -i.bak "s/from: \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/from: \"$BRAINTREE_VERSION\"/g" README.md
rm README.md.bak 

# Clean up unzipped frameworks only if we regenerated them
if [ "$NEED_REGENERATE" = true ] || [ "$FORCE_REGENERATE" = true ]; then
    echo "Cleaning up unzipped frameworks..."
    rm -rf $XCFRAMEWORK_DIR/Carthage
    rm -f $TEMP_DIR/Braintree.xcframework.zip
    echo "✅ Cleanup complete. Only zipped frameworks and XCFrameworks directory remain."
fi 

# Extract PrivacyInfo files from framework zips
echo "Extracting PrivacyInfo files..."
rm -rf Sources
mkdir -p Sources

# Download and extract PrivacyInfo files from source code
download_privacy_info() {
    local version=$1
    local temp_zip="$TEMP_DIR/braintree_source.zip"
    local temp_src="$TEMP_DIR/braintree_src"
    local source_url="https://github.com/braintree/braintree_ios/archive/refs/tags/$version.zip"
    
    echo "Downloading Braintree source code from $source_url..."
    curl -L "$source_url" -o "$temp_zip"
    
    echo "Extracting source code..."
    rm -rf "$temp_src"
    mkdir -p "$temp_src"
    unzip -q "$temp_zip" -d "$temp_src"
    
    # The extracted folder will be named braintree_ios-{version}
    local src_dir="$temp_src/braintree_ios-$version"
    local workspace_dir="$PWD"
    
    # Copy entire Sources directory
    echo "Copying source files..."
    rm -rf "$workspace_dir/Sources"
    mkdir -p "$workspace_dir/Sources"
    cp -R "$src_dir/Sources/"* "$workspace_dir/Sources/"
    echo "✅ Copied all source files"
    
    # Update Package-original.swift from source code
    echo "Updating Package-original.swift..."
    if [ -f "$src_dir/Package.swift" ]; then
        cp "$src_dir/Package.swift" "$workspace_dir/Package-original.swift"
        echo "✅ Updated Package-original.swift from source code"
    else
        echo "Warning: Package.swift not found in source code"
    fi
    
    # Clean up
    rm -rf "$temp_zip" "$temp_src"
}

# Extract source files and PrivacyInfo files from source code
download_privacy_info "$BRAINTREE_VERSION"

echo "✅ Source files extraction complete"

# Final cleanup - remove entire temp directory
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
echo "✅ Cleanup complete" 