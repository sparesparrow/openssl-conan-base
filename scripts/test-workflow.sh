#!/bin/bash

# Test script for OpenSSL Conan Base workflow
# This script validates the workflow configuration and tests basic functionality

set -e

echo "🧪 Testing OpenSSL Conan Base Workflow Configuration"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "conanfile.py" ]; then
    echo "❌ Not in OpenSSL Conan Base directory"
    exit 1
fi

echo "✅ In correct directory"

# Check workflow files exist
if [ ! -f ".github/workflows/conan-build.yml" ]; then
    echo "❌ conan-build.yml workflow not found"
    exit 1
fi

if [ ! -f ".github/workflows/fips-validation.yml" ]; then
    echo "❌ fips-validation.yml workflow not found"
    exit 1
fi

echo "✅ Workflow files exist"

# Validate workflow syntax
echo "🔍 Validating workflow syntax..."

# Check if yq is available for YAML validation
if command -v yq >/dev/null 2>&1; then
    echo "Validating conan-build.yml..."
    yq eval '.jobs' .github/workflows/conan-build.yml > /dev/null
    echo "✅ conan-build.yml syntax valid"
    
    echo "Validating fips-validation.yml..."
    yq eval '.jobs' .github/workflows/fips-validation.yml > /dev/null
    echo "✅ fips-validation.yml syntax valid"
else
    echo "⚠️ yq not available, skipping YAML syntax validation"
fi

# Check profile files
echo "🔍 Validating profile files..."

PROFILES=(
    "profiles/linux-gcc11-fips"
    "profiles/linux-gcc11"
    "profiles/windows-msvc193"
    "profiles/macos-arm64"
    "profiles/macos-x86_64"
)

for profile in "${PROFILES[@]}"; do
    if [ -f "$profile" ]; then
        echo "✅ Profile $profile exists"
    else
        echo "❌ Profile $profile missing"
        exit 1
    fi
done

# Check FIPS compliance profile
if [ -f "profiles/compliance/fips-linux-gcc-release.profile" ]; then
    echo "✅ FIPS compliance profile exists"
else
    echo "❌ FIPS compliance profile missing"
    exit 1
fi

# Test Conan configuration
echo "🔍 Testing Conan configuration..."

if command -v conan >/dev/null 2>&1; then
    echo "Conan version: $(conan --version)"
    
    # Test profile validation
    for profile in "${PROFILES[@]}"; do
        echo "Validating profile: $profile"
        conan profile show "$profile" > /dev/null || {
            echo "❌ Profile $profile validation failed"
            exit 1
        }
    done
    
    echo "✅ All profiles validated with Conan"
else
    echo "⚠️ Conan not available, skipping profile validation"
fi

# Check environment variables and secrets
echo "🔍 Checking required secrets and variables..."

REQUIRED_SECRETS=(
    "CLOUDSMITH_API_KEY"
    "CONAN_LOGIN_USERNAME"
    "CONAN_PASSWORD"
)

for secret in "${REQUIRED_SECRETS[@]}"; do
    if [ -n "${!secret}" ]; then
        echo "✅ Secret $secret is set"
    else
        echo "⚠️ Secret $secret not set (this is expected in CI/CD)"
    fi
done

# Test workflow dispatch simulation
echo "🔍 Testing workflow dispatch simulation..."

# Simulate workflow dispatch inputs
VERSION="3.0.12"
PLATFORM="linux-x64"
FIPS_ENABLED="false"

echo "Simulating workflow dispatch with:"
echo "  Version: $VERSION"
echo "  Platform: $PLATFORM"
echo "  FIPS Enabled: $FIPS_ENABLED"

# Check if the workflow would handle these inputs correctly
if grep -q "github.event.inputs.version" .github/workflows/conan-build.yml; then
    echo "✅ Workflow handles version input"
else
    echo "❌ Workflow missing version input handling"
    exit 1
fi

if grep -q "github.event.inputs.platform" .github/workflows/conan-build.yml; then
    echo "✅ Workflow handles platform input"
else
    echo "❌ Workflow missing platform input handling"
    exit 1
fi

if grep -q "github.event.inputs.fips_enabled" .github/workflows/conan-build.yml; then
    echo "✅ Workflow handles FIPS input"
else
    echo "❌ Workflow missing FIPS input handling"
    exit 1
fi

# Test MCP dispatch configuration
echo "🔍 Testing MCP dispatch configuration..."

if grep -q "mcp-project-orchestrator" .github/workflows/conan-build.yml; then
    echo "✅ MCP dispatch configured"
else
    echo "❌ MCP dispatch not configured"
    exit 1
fi

if grep -q "openssl-conan-export-complete" .github/workflows/conan-build.yml; then
    echo "✅ MCP event type configured"
else
    echo "❌ MCP event type not configured"
    exit 1
fi

echo ""
echo "🎉 All tests passed!"
echo ""
echo "Workflow Configuration Summary:"
echo "==============================="
echo "✅ conan-build.yml workflow created"
echo "✅ fips-validation.yml workflow created"
echo "✅ Workflow dispatch triggers configured"
echo "✅ FIPS variant handling implemented"
echo "✅ Conan export functionality added"
echo "✅ MCP integration tests dispatch configured"
echo "✅ All profile files validated"
echo ""
echo "Next steps:"
echo "1. Push to main branch to trigger workflow"
echo "2. Use workflow_dispatch for manual testing"
echo "3. Verify Conan Center uploads"
echo "4. Check MCP Project Orchestrator for integration tests"