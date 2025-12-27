# OpenSSL Conan Base - Foundation Package

## 📦 Package Overview
- **Name**: `openssl-base`
- **Version**: `1.0.1` (current)
- **Channel**: `stable`
- **User**: `sparesparrow`
- **Purpose**: Foundation utilities, profiles, and Python runtime for OpenSSL ecosystem

## 🔄 Version Management Rules

### Before Making Changes
1. **ALWAYS update version first** in `conanfile.py`
2. **NEVER modify conanfile.py** without version bump
3. **Commit version change** before calling `conan create`

### Version Update Workflow
```bash
# 1. Update version in conanfile.py
version = "1.0.2"  # Increment patch version

# 2. Commit the change
git add conanfile.py
git commit -m "bump: openssl-base to 1.0.2"

# 3. Build and upload
conan create . --build=missing
conan upload openssl-base/1.0.2@sparesparrow/stable -r=sparesparrow-conan
```

## 📋 Package Contents

### Exported Sources
- `openssl_base/*` - Python utilities (version_manager, sbom_generator, profile_deployer)
- `profiles/*` - Conan build profiles
- `python_env/*` - Python environment configuration

### Package Artifacts
- **Python modules**: `openssl_base/` directory with all Python files
- **Profiles**: `profiles/` directory with `.profile` files
- **Licenses**: `README.md` in licenses folder

### Environment Variables
- `OPENSSL_PROFILES_PATH` - Path to profiles directory
- `OPENSSL_BASE_VERSION` - Package version
- `PYTHONPATH` - Prepend package folder for Python imports

## 🏗️ Build Process

### Dependencies
- **None** - This is a foundation package

### Build Commands
```bash
# Install dependencies
conan install . --build=missing

# Create package
conan create . --build=missing

# Upload to remote
conan upload openssl-base/1.0.1@sparesparrow/stable -r=sparesparrow-conan
```

## 🧪 Validation

### Package Validation
```bash
# Check package contents
conan cache path openssl-base/1.0.1@sparesparrow/stable

# Validate with script
python ../scripts/validate-conan-packages.py openssl-base/1.0.1
```

### Expected Contents
- ✅ `openssl_base/` directory with Python files
- ✅ `profiles/` directory with profile files
- ✅ Environment variables properly set
- ✅ No C++ libraries or binaries (this is a Python package)

## 🔗 Dependencies

### Consumed By
- `openssl-tools` - Requires this package for utilities
- `openssl` - May require this package for profiles

### Version Compatibility
- **Major version changes** (1.x → 2.x): Breaking changes, update all consumers
- **Minor version changes** (1.0.x → 1.1.x): New features, backward compatible
- **Patch version changes** (1.0.0 → 1.0.1): Bug fixes, fully backward compatible

## 🚨 Critical Notes

1. **Foundation Package**: This is the base of the dependency chain
2. **Stable Channel**: Always use stable channel for reliability
3. **Python Package**: No C++ compilation, just Python utilities
4. **Profile Provider**: Provides Conan build profiles for other packages
5. **Version Manager**: Contains version management utilities for OpenSSL ecosystem

## 📝 Change Log

### Version 1.0.1
- Fixed package() method to properly copy Python files
- Added proper package_info() with environment variables
- Removed dependency on non-existent base_conanfile

### Version 1.0.0
- Initial release with basic utilities
- Version manager, SBOM generator, profile deployer