# OpenSSL Conan Base

Foundation profiles for OpenSSL Conan ecosystem.

## Usage

```bash
conan remote add sparesparrow-conan https://conan.cloudsmith.io/sparesparrow-conan/openssl-conan/ --force
conan install --requires=openssl-base/1.0.0 -r=sparesparrow-conan
```

## Architecture

```mermaid
graph LR
  A[profiles] --> B[openssl-base/1.0.0]
  B --> C[openssl-build-tools]
```
