import os
from conan import ConanFile
from conan.tools.files import copy


class OpenSSLBaseConan(ConanFile):
    name = "openssl-base"
    version = "1.0.1"
    description = "Foundation: profiles and Python runtime"
    license = "Apache-2.0"
    url = "https://github.com/sparesparrow/openssl-conan-base"
    exports_sources = "openssl_base/*", "profiles/*", "python_env/*"

    def init(self):
        # Set default channel for foundation packages
        if not os.getenv("CONAN_CHANNEL"):
            self.user = "sparesparrow"
            self.channel = "stable"  # Foundation packages are typically stable

    def package(self):
        copy(self, "*.py", src=os.path.join(self.source_folder, "openssl_base"), 
             dst=os.path.join(self.package_folder, "openssl_base"), keep_path=True)
        copy(self, "*.profile", src=os.path.join(self.source_folder, "profiles"), 
             dst=os.path.join(self.package_folder, "profiles"), keep_path=True)
        copy(self, "README.md", src=self.source_folder, 
             dst=os.path.join(self.package_folder, "licenses"))

    def package_info(self):
        self.cpp_info.bindirs = []
        self.cpp_info.libdirs = []
        self.runenv_info.define("OPENSSL_PROFILES_PATH", 
                                os.path.join(self.package_folder, "profiles"))
        self.runenv_info.define("OPENSSL_BASE_VERSION", self.version)
        # Add Python path
        self.runenv_info.prepend_path("PYTHONPATH", self.package_folder)
