#!/bin/bash

set -e

VERSION="${1:-137.7151.03}"
FRAMEWORK_NAME="LiveKitWebRTC"
DOWNLOAD_URL="https://github.com/livekit/webrtc-xcframework/releases/download/${VERSION}/${FRAMEWORK_NAME}.xcframework.zip"

echo "Extracting dSYMs from ${FRAMEWORK_NAME} version ${VERSION}"

# Download and extract XCFramework
TEMP_DIR="temp_dsym"
rm -rf "${TEMP_DIR}" "dSYMs"
mkdir -p "${TEMP_DIR}"

echo "Downloading XCFramework..."
curl -L "${DOWNLOAD_URL}" -o "${TEMP_DIR}/${FRAMEWORK_NAME}.xcframework.zip"

echo "Extracting..."
cd "${TEMP_DIR}"
unzip -q "${FRAMEWORK_NAME}.xcframework.zip"
cd ..

# Extract dSYMs if they exist
mkdir -p "dSYMs"
if find "${TEMP_DIR}/${FRAMEWORK_NAME}.xcframework" -name "*.dSYM" -type d | grep -q .; then
    echo "Found dSYMs, extracting..."
    find "${TEMP_DIR}/${FRAMEWORK_NAME}.xcframework" -name "*.dSYM" -type d -exec cp -R {} "dSYMs/" \;
    
    # Create dSYM archive
    cd "dSYMs"
    zip -r -q "../${FRAMEWORK_NAME}.dSYMs.zip" .
    cd ..
    echo "dSYMs extracted to ${FRAMEWORK_NAME}.dSYMs.zip"
else
    echo "No dSYMs found in the XCFramework"
fi

# Clean up
rm -rf "${TEMP_DIR}" "dSYMs"