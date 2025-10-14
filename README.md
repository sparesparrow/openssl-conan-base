# OpenSSL Conan Base

Foundation profiles for OpenSSL Conan ecosystem.

## Usage

```bash
conan remote add ${CONAN_REPOSITORY_NAME} ${CONAN_REPOSITORY_URL} --force
conan install --requires=openssl-base/1.0.0 -r=${CONAN_REPOSITORY_NAME}
```

## Architecture

```mermaid
graph LR
  A[profiles] --> B[openssl-base/1.0.0]
  B --> C[openssl-build-tools]
```
