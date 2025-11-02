#!/bin/bash
# Simple verification script for PR #4 requirements

echo "🔍 Verifying PR #4 Requirements"
echo "================================"

# Check critical files
echo ""
echo "📁 Checking critical files:"

if [ -f ".github/workflows/security-scanning.yml" ]; then
    echo "✅ Security scanning workflow exists"
else
    echo "❌ Security scanning workflow missing"
fi

if [ -f ".github/workflows/codeql-analysis.yml" ]; then
    echo "✅ CodeQL workflow exists"
else
    echo "❌ CodeQL workflow missing"
fi

if [ -f "scripts/fips_validation.sh" ]; then
    echo "✅ FIPS validation script exists"
else
    echo "❌ FIPS validation script missing"
fi

# Check conanfile.py
echo ""
echo "🐍 Checking conanfile.py:"

if grep -q "python_requires.*openssl-tools" conanfile.py; then
    echo "✅ python_requires dependency found"
else
    echo "❌ python_requires dependency missing"
fi

if grep -q "build_openssl_with_fips" conanfile.py; then
    echo "✅ openssl-tools integration found"
else
    echo "❌ openssl-tools integration missing"
fi

# Check build matrix
echo ""
echo "🔧 Checking build matrix:"

if grep -q "linux-gcc11" .github/workflows/conan-build.yml; then
    echo "✅ Linux GCC11 profile found"
else
    echo "❌ Linux GCC11 profile missing"
fi

if grep -q "windows-msvc193" .github/workflows/conan-build.yml; then
    echo "✅ Windows MSVC193 profile found"
else
    echo "❌ Windows MSVC193 profile missing"
fi

if grep -q "macos-arm64" .github/workflows/conan-build.yml; then
    echo "✅ macOS ARM64 profile found"
else
    echo "❌ macOS ARM64 profile missing"
fi

# Check variants
echo ""
echo "🏷️  Checking variants:"

if grep -q "variant.*general" .github/workflows/conan-build.yml; then
    echo "✅ General variant found"
else
    echo "❌ General variant missing"
fi

if grep -q "variant.*fips-government" .github/workflows/conan-build.yml; then
    echo "✅ FIPS Government variant found"
else
    echo "❌ FIPS Government variant missing"
fi

if grep -q "variant.*embedded" .github/workflows/conan-build.yml; then
    echo "✅ Embedded variant found"
else
    echo "❌ Embedded variant missing"
fi

# Check security scanning
echo ""
echo "🔒 Checking security scanning:"

if grep -q "trivy-action" .github/workflows/security-scanning.yml; then
    echo "✅ Trivy CVE scanning found"
else
    echo "❌ Trivy CVE scanning missing"
fi

if grep -q "anchore/sbom-action" .github/workflows/security-scanning.yml; then
    echo "✅ SBOM generation found"
else
    echo "❌ SBOM generation missing"
fi

# Check MCP integration
echo ""
echo "🔗 Checking MCP integration:"

if grep -q "mcp-project-orchestrator" .github/workflows/conan-build.yml; then
    echo "✅ MCP Project Orchestrator dispatch found"
else
    echo "❌ MCP Project Orchestrator dispatch missing"
fi

if grep -q "openssl-conan-export-complete" .github/workflows/conan-build.yml; then
    echo "✅ MCP event type found"
else
    echo "❌ MCP event type missing"
fi

# Check Cloudsmith publishing
echo ""
echo "☁️  Checking Cloudsmith publishing:"

if grep -q "sparesparrow-conan/openssl-conan" .github/workflows/conan-build.yml; then
    echo "✅ Correct Cloudsmith repository found"
else
    echo "❌ Correct Cloudsmith repository missing"
fi

echo ""
echo "🎉 Verification complete!"