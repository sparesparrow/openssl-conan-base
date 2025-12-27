#!/bin/bash
set -e

BUILD_TYPE="${1:-Release}"
OUTPUT_DIR="${2:-full_deploy}"

echo "Building full_deploy bundle for $BUILD_TYPE..."

# Ensure Conan extensions are installed
conan config install https://github.com/conan-io/conan-extensions.git

# Build the full_deploy bundle
conan install . \
  --output-folder="$OUTPUT_DIR" \
  --build=missing \
  --settings=build_type="$BUILD_TYPE" \
  --deployer=full_deploy

# Zip the deploy folder for distribution
if [ -f "${OUTPUT_DIR}.zip" ]; then
  rm "${OUTPUT_DIR}.zip"
fi

cd "$OUTPUT_DIR"
zip -r "../${OUTPUT_DIR}.zip" .
cd ..

echo "full_deploy bundle created at: ${OUTPUT_DIR}.zip"
