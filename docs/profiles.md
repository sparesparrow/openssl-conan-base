# Conan Profiles Documentation

This document describes the Conan profiles available in this repository and how to use them across different projects.

## Available Profiles

### Linux Profiles

#### `linux-gcc11-fips`
- **Platform**: Linux x86_64
- **Compiler**: GCC 11
- **Features**: FIPS 140-3 enabled, QUIC support
- **Use Case**: Production builds requiring FIPS compliance

```bash
conan install . --profile:all=profiles/linux-gcc11-fips
```

#### `linux-gcc11` (Standard)
- **Platform**: Linux x86_64  
- **Compiler**: GCC 11
- **Features**: Standard OpenSSL build
- **Use Case**: Development and testing

#### `linux-arm64-gcc`
- **Platform**: Linux ARM64
- **Compiler**: GCC
- **Features**: ARM64 optimized build
- **Use Case**: ARM-based servers and devices

### Windows Profiles

#### `windows-msvc193`
- **Platform**: Windows x86_64
- **Compiler**: MSVC 2022 (v193)
- **Features**: FIPS enabled, dynamic runtime
- **Use Case**: Windows production builds

```bash
conan install . --profile:all=profiles/windows-msvc193
```

#### `windows-msvc193-shared`
- **Platform**: Windows x86_64
- **Compiler**: MSVC 2022 (v193)
- **Features**: Shared library build
- **Use Case**: Windows applications requiring shared OpenSSL

### macOS Profiles

#### `macos-arm64`
- **Platform**: macOS ARM64 (Apple Silicon)
- **Compiler**: Apple Clang 14
- **Features**: FIPS enabled, QUIC support
- **Use Case**: Apple Silicon Macs

```bash
conan install . --profile:all=profiles/macos-arm64
```

#### `macos-x86_64`
- **Platform**: macOS x86_64 (Intel)
- **Compiler**: Apple Clang
- **Features**: Intel Mac compatibility
- **Use Case**: Intel-based Macs

## Cross-Repository Usage

### GitHub Actions Matrix

Use these profiles in your GitHub Actions workflows:

```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-22.04
        profile: linux-gcc11-fips
        arch: x86_64
      - os: windows-2022
        profile: windows-msvc193
        arch: x86_64
      - os: macos-13
        profile: macos-arm64
        arch: arm64

steps:
  - name: Build with profile
    run: |
      conan install . \
        --profile:all=profiles/${{ matrix.profile }} \
        --build=missing
```

### Reusable Workflow Integration

Reference this repository's profiles in other projects:

```yaml
jobs:
  build:
    uses: sparesparrow/openssl-conan-base/.github/workflows/build-and-publish.yml@main
    with:
      profiles: |
        linux-gcc11-fips
        windows-msvc193
        macos-arm64
```

### Profile Validation

Before using profiles, validate they exist:

```bash
# List available profiles
conan profile list

# Show profile details
conan profile show profiles/linux-gcc11-fips

# Validate profile syntax
conan profile detect --force
```

## Profile Configuration Details

### Common Settings

All profiles include:
- `build_type=Release`
- `tools.cmake.cmaketoolchain:generator=Ninja`
- `openssl*:shared=True` (for dynamic linking)

### FIPS-Specific Settings

FIPS-enabled profiles include:
- `openssl*:enable_fips=True`
- `openssl*:enable_quic=True` (where supported)

### Compiler-Specific Settings

#### GCC Profiles
```ini
compiler=gcc
compiler.version=11
compiler.libcxx=libstdc++11
```

#### MSVC Profiles
```ini
compiler=msvc
compiler.version=193
compiler.runtime=dynamic
```

#### Apple Clang Profiles
```ini
compiler=apple-clang
compiler.version=14
compiler.libcxx=libc++
```

## Troubleshooting

### Profile Not Found
```bash
# Ensure profile path is correct
ls profiles/linux-gcc11-fips

# Check Conan configuration
conan config list
```

### Build Failures
```bash
# Clean Conan cache
conan cache clean "*"

# Re-detect profiles
conan profile detect --force
```

### Cross-Compilation Issues
```bash
# Verify target architecture
conan profile show profiles/linux-arm64-gcc

# Check compiler availability
gcc --version
```

## Integration Examples

### CMake Integration
```cmake
# In your CMakeLists.txt
find_package(OpenSSL REQUIRED)
target_link_libraries(your_target OpenSSL::SSL OpenSSL::Crypto)
```

### Conanfile.py Integration
```python
# In your conanfile.py
def requirements(self):
    self.requires("openssl/3.6.0")
    
def configure(self):
    if self.settings.os == "Linux" and self.settings.arch == "x86_64":
        self.options["openssl"].enable_fips = True
```

### Docker Integration
```dockerfile
# In your Dockerfile
COPY profiles/ /conan/profiles/
RUN conan install . --profile:all=/conan/profiles/linux-gcc11-fips
```

## Security Considerations

- FIPS profiles are required for production deployments
- Always validate profile integrity before use
- Use signed profiles in CI/CD environments
- Regularly update compiler versions for security patches

## Support

For profile-related issues:
1. Check this documentation
2. Validate profile syntax with `conan profile show`
3. Test with minimal reproduction case
4. Open issue with profile details and error logs