#!/bin/bash
# verify-pr-requirements.sh - Comprehensive verification script for PR #4 requirements

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

# Check if file exists and contains pattern
check_file_contains() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    if [ -f "$file" ]; then
        if grep -q "$pattern" "$file"; then
            log_success "$description"
            return 0
        else
            log_error "$description - Pattern not found: $pattern"
            return 1
        fi
    else
        log_error "$description - File not found: $file"
        return 1
    fi
}

# Check if workflow exists
check_workflow_exists() {
    local workflow="$1"
    local description="$2"
    
    if [ -f ".github/workflows/$workflow" ]; then
        log_success "$description"
        return 0
    else
        log_error "$description - Workflow not found: $workflow"
        return 1
    fi
}

echo "🔍 Verifying PR #4 Requirements"
echo "================================"
echo ""

# Phase 1: Security Foundation (BLOCKER)
log_info "Phase 1: Security Foundation Verification"
echo "----------------------------------------------"

# Check for SBOM generation workflow
check_workflow_exists "security-scanning.yml" "SBOM generation workflow"

# Check for Trivy CVE scanning
check_file_contains ".github/workflows/security-scanning.yml" "trivy-action" "Trivy CVE scanning"

# Check for FIPS validation script
if [ -f "scripts/fips_validation.sh" ]; then
    if [ -x "scripts/fips_validation.sh" ]; then
        log_success "FIPS validation script (executable)"
    else
        log_error "FIPS validation script (not executable)"
    fi
else
    log_error "FIPS validation script (missing)"
fi

# Check for CodeQL workflow
check_workflow_exists "codeql-analysis.yml" "CodeQL security analysis workflow"

echo ""

# Phase 2: Architecture Validation (CRITICAL)
log_info "Phase 2: Architecture Validation"
echo "------------------------------------"

# Check python_requires in conanfile.py
check_file_contains "conanfile.py" "python_requires.*openssl-tools" "python_requires dependency declaration"

# Check build method using openssl-tools
check_file_contains "conanfile.py" "build_openssl_with_fips" "openssl-tools integration in build method"

# Check build matrix includes required platforms
check_file_contains ".github/workflows/conan-build.yml" "linux-gcc11" "Linux GCC11 profile in build matrix"
check_file_contains ".github/workflows/conan-build.yml" "windows-msvc193" "Windows MSVC193 profile in build matrix"
check_file_contains ".github/workflows/conan-build.yml" "macos-arm64" "macOS ARM64 profile in build matrix"

# Check for variant support
check_file_contains ".github/workflows/conan-build.yml" "variant.*general" "General variant support"
check_file_contains ".github/workflows/conan-build.yml" "variant.*fips-government" "FIPS Government variant support"
check_file_contains ".github/workflows/conan-build.yml" "variant.*embedded" "Embedded variant support"

echo ""

# Phase 3: Production Hardening (REQUIRED)
log_info "Phase 3: Production Hardening"
echo "---------------------------------"

# Check workflow dispatch payload
check_file_contains ".github/workflows/conan-build.yml" "openssl-conan-export-complete" "MCP dispatch event type"
check_file_contains ".github/workflows/conan-build.yml" "mcp-project-orchestrator" "MCP Project Orchestrator dispatch"

# Check Cloudsmith publishing
check_file_contains ".github/workflows/conan-build.yml" "sparesparrow-conan/openssl-conan" "Correct Cloudsmith repository"
check_file_contains ".github/workflows/conan-build.yml" "cloudsmith push raw" "Cloudsmith raw package publishing"

# Check for proper artifact management
check_file_contains ".github/workflows/conan-build.yml" "retention-days: 30" "Artifact retention policy"

echo ""

# Phase 4: FIPS Compliance Verification
log_info "Phase 4: FIPS Compliance Verification"
echo "----------------------------------------"

# Check FIPS validation script content
if [ -f "scripts/fips_validation.sh" ]; then
    check_file_contains "scripts/fips_validation.sh" "Phase 1.*Environment Validation" "FIPS Phase 1 validation"
    check_file_contains "scripts/fips_validation.sh" "Phase 2.*FIPS Module Integrity" "FIPS Phase 2 validation"
    check_file_contains "scripts/fips_validation.sh" "Phase 3.*FIPS Configuration" "FIPS Phase 3 validation"
    check_file_contains "scripts/fips_validation.sh" "Phase 4.*Self-Test" "FIPS Phase 4 validation"
    check_file_contains "scripts/fips_validation.sh" "Phase 5.*FIPS Module Operation" "FIPS Phase 5 validation"
    check_file_contains "scripts/fips_validation.sh" "Certificate.*4985" "FIPS Certificate #4985 validation"
fi

# Check FIPS profiles
check_file_contains "profiles/linux-gcc11-fips" "enable_fips=True" "FIPS enabled in Linux profile"
check_file_contains "profiles/linux-gcc11-fips" "enable_quic=True" "QUIC enabled in FIPS profile"

echo ""

# Phase 5: Security Scanning Integration
log_info "Phase 5: Security Scanning Integration"
echo "------------------------------------------"

# Check for security gate
check_file_contains ".github/workflows/security-scanning.yml" "Security Gate" "Security gate implementation"
check_file_contains ".github/workflows/security-scanning.yml" "CRITICAL_COUNT" "Critical vulnerability counting"
check_file_contains ".github/workflows/security-scanning.yml" "SECURITY GATE FAILED" "Security gate failure handling"

# Check for SBOM generation
check_file_contains ".github/workflows/security-scanning.yml" "anchore/sbom-action" "Anchore SBOM generation"
check_file_contains ".github/workflows/security-scanning.yml" "cyclonedx-json" "CycloneDX SBOM format"

echo ""

# Phase 6: Workflow Integration
log_info "Phase 6: Workflow Integration"
echo "--------------------------------"

# Check for proper workflow triggers
check_file_contains ".github/workflows/conan-build.yml" "workflow_dispatch" "Manual workflow dispatch"
check_file_contains ".github/workflows/conan-build.yml" "push.*branches.*main" "Push to main trigger"
check_file_contains ".github/workflows/conan-build.yml" "pull_request.*branches.*main" "Pull request trigger"

# Check for input parameters
check_file_contains ".github/workflows/conan-build.yml" "version.*description" "Version input parameter"
check_file_contains ".github/workflows/conan-build.yml" "platform.*description" "Platform input parameter"
check_file_contains ".github/workflows/conan-build.yml" "fips_enabled.*description" "FIPS enabled input parameter"

echo ""

# Summary
log_info "Verification Summary"
echo "======================"
echo "✅ Passed: $PASSED"
echo "⚠️  Warnings: $WARNINGS"
echo "❌ Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    log_success "All critical requirements verified successfully!"
    echo ""
    echo "🎉 PR #4 is ready for merge approval!"
    echo ""
    echo "Next steps:"
    echo "1. Push changes to trigger CI/CD pipeline"
    echo "2. Verify all workflows execute successfully"
    echo "3. Check security scanning results"
    echo "4. Validate FIPS compliance reports"
    echo "5. Confirm MCP integration tests"
    exit 0
else
    log_error "Critical requirements verification failed!"
    echo ""
    echo "❌ PR #4 requires fixes before merge approval"
    echo ""
    echo "Failed checks:"
    echo "- Review the failed items above"
    echo "- Fix critical issues before proceeding"
    echo "- Re-run this verification script"
    exit 1
fi