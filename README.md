# OpenSSL Conan Base - Foundation Layer

Foundation utilities and profiles for OpenSSL Conan ecosystem.

## Features

- **Platform Profiles**: Pre-configured profiles for Linux, Windows, macOS
- **CI/CD Workflows**: Automated multi-platform builds
- **Artifact Management**: Cloudsmith integration for portable bundles
- **Security Scanning**: SBOM generation and CVE scanning

## Profiles

Available profiles in `profiles/`:

- `linux-gcc11-fips` - Linux x86_64 with GCC 11 and FIPS enabled
- `windows-msvc193` - Windows x86_64 with MSVC 2022
- `macos-arm64` - macOS ARM64 with Apple Clang

## Usage

### Using profiles
```bash
# Setup environment (optional)
export CONAN_USER=sparesparrow
export CONAN_CHANNEL=stable

# Install with user/channel reference
conan install --requires=openssl-base/1.0.0@${CONAN_USER}/${CONAN_CHANNEL} --profile=profiles/linux-gcc11-fips
```

### User/Channel Support

This package supports Conan user/channel references for different environments:

- **Stable**: `openssl-base/1.0.0@sparesparrow/stable`
- **Development**: `openssl-base/1.0.0@sparesparrow/dev`
- **Testing**: `openssl-base/1.0.0@sparesparrow/testing`

### CI/CD Integration

The repository includes comprehensive GitHub Actions workflows:

#### Build and Publish Workflow

```yaml
# .github/workflows/build-and-publish.yml
name: Build and Publish OpenSSL Packages

on:
  push:
    branches: [main]
    tags: ['v*']
  schedule:
    - cron: '0 6 * * 1'  # Weekly rebuild
```

**Features**:
- **Multi-platform builds**: Linux (x86_64, ARM64), Windows (x86_64), macOS (x86_64, ARM64)
- **FIPS support**: Automated FIPS 140-3 validation
- **Security scanning**: SBOM generation and vulnerability scanning
- **Cloudsmith integration**: Automated package publishing
- **Release management**: GitHub releases with artifact bundles

#### Build Matrix

| Platform | Profile | FIPS | Architecture |
|----------|---------|------|-------------|
| Ubuntu 22.04 | linux-gcc11-fips | ✅ | x86_64 |
| Ubuntu 22.04 | linux-gcc11 | ❌ | x86_64 |
| Ubuntu 22.04 | linux-arm64-gcc | ❌ | ARM64 |
| Windows 2022 | windows-msvc193 | ❌ | x86_64 |
| Windows 2022 | windows-msvc193-shared | ❌ | x86_64 |
| macOS 13 | macos-arm64 | ❌ | ARM64 |
| macOS 13 | macos-x86_64 | ❌ | x86_64 |

#### Security Integration

- **SBOM Generation**: CycloneDX format for all packages
- **Vulnerability Scanning**: Trivy + CodeQL integration
- **GitHub Security**: SARIF upload to Security tab
- **FIPS Validation**: Automated FIPS 140-3 compliance testing

## Architecture

```
openssl-conan-base/
├── profiles/                         # Platform-specific profiles
│   ├── linux-gcc11-fips
│   ├── windows-msvc193
│   └── macos-arm64
├── .github/workflows/
│   └── build-deploy-artifacts.yml    # Multi-platform CI/CD
└── README.md
```

## Integration with openssl-tools

This repository works with `sparesparrow/openssl-tools`:
- Uses `openssl-tools` python_requires for build orchestration
- Installs extensions via `conan config install`
- Generates artifacts using `full_deploy_enhanced` deployer