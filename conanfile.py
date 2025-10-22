import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "templates"))

from base_conanfile import OpenSSLFoundationConan
from conan.tools.files import copy


class OpenSSLBaseConan(OpenSSLFoundationConan):
    name = "openssl-base"
    version = "1.0.0"
    description = "Foundation: profiles and Python runtime"
    license = "Apache-2.0"
    url = "https://github.com/sparesparrow/openssl-conan-base"
    exports_sources = "openssl_base/*", "profiles/*", "python_env/*"
    
    # Dependencies
    python_requires = "openssl-tools/[>=1.0.0]"

    def init(self):
        super().init()
        # Set default channel for foundation packages
        if not os.getenv("CONAN_CHANNEL"):
            self.channel = "stable"  # Foundation packages are typically stable

    def build(self):
        # Use openssl-tools for build logic
        tools = self.python_requires["openssl-tools"].module
        if hasattr(tools, 'build_openssl_with_fips'):
            tools.build_openssl_with_fips(self)
        else:
            # Fallback to standard build process
            super().build()

    def package(self):
        copy(self, "*.profile", src=os.path.join(self.source_folder, "profiles"), dst=os.path.join(self.package_folder, "profiles"), keep_path=True)

    def package_info(self):
        super().package_info()
        self.runenv_info.define("OPENSSL_PROFILES_PATH", os.path.join(self.package_folder, "profiles"))
        self.runenv_info.define("OPENSSL_BASE_VERSION", self.version)
