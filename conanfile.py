"""
OpenSSL Base Foundation Package
Provides core utilities, profiles, and Python runtime for OpenSSL ecosystem
"""

import os
from conan import ConanFile
from conan.tools.files import copy
from conan.tools.layout import basic_layout
from conan.tools.cmake import CMake, cmake_layout


class OpenSSLBaseConan(ConanFile):
    name = "openssl-base"
    version = "1.0.1"
    description = "Foundation: profiles, utilities, and Python runtime for OpenSSL ecosystem"
    license = "Apache-2.0"
    url = "https://github.com/sparesparrow/openssl-conan-base"
    homepage = "https://github.com/sparesparrow/openssl-conan-base"
    topics = ("openssl", "foundation", "utilities", "profiles", "python")

    # Package settings
    settings = "os", "arch", "compiler", "build_type"
    package_type = "python-require"

    # Export sources
    exports_sources = (
        "openssl_base/*",
        "profiles/*",
        "python_env/*",
        "scripts/*",
        "templates/*",
        "tests/*",
        "pyproject.toml",
        "*.md"
    )

    def init(self):
        """Initialize package with proper channel"""
        if not os.getenv("CONAN_CHANNEL"):
            self.user = "sparesparrow"
            self.channel = "stable"  # Foundation packages are typically stable

    def layout(self):
        """Define package layout for consistency"""
        basic_layout(self)

    def requirements(self):
        """Foundation package has no dependencies"""
        pass

    def package(self):
        """Package all foundation components"""
        # Copy Python modules
        copy(self, "*.py", src=os.path.join(self.source_folder, "openssl_base"),
             dst=os.path.join(self.package_folder, "openssl_base"), keep_path=True)

        # Copy profiles
        copy(self, "*.profile", src=os.path.join(self.source_folder, "profiles"),
             dst=os.path.join(self.package_folder, "profiles"), keep_path=True)

        # Copy scripts and utilities
        copy(self, "*", src=os.path.join(self.source_folder, "scripts"),
             dst=os.path.join(self.package_folder, "scripts"), keep_path=True)

        # Copy templates
        copy(self, "*", src=os.path.join(self.source_folder, "templates"),
             dst=os.path.join(self.package_folder, "templates"), keep_path=True)

        # Copy Python environment files
        copy(self, "*", src=os.path.join(self.source_folder, "python_env"),
             dst=os.path.join(self.package_folder, "python_env"), keep_path=True)

        # Copy documentation and licenses
        copy(self, "README.md", src=self.source_folder,
             dst=os.path.join(self.package_folder, "licenses"))
        copy(self, "LICENSE*", src=self.source_folder,
             dst=os.path.join(self.package_folder, "licenses"))

        # Copy package configuration
        copy(self, "pyproject.toml", src=self.source_folder,
             dst=self.package_folder)

    def package_info(self):
        """Define package information and environment"""
        # No C++ components
        self.cpp_info.bindirs = []
        self.cpp_info.libdirs = []
        self.cpp_info.includedirs = []

        # Environment variables
        self.runenv_info.define("OPENSSL_PROFILES_PATH",
                                os.path.join(self.package_folder, "profiles"))
        self.runenv_info.define("OPENSSL_BASE_VERSION", self.version)
        self.runenv_info.define("OPENSSL_BASE_ROOT", self.package_folder)

        # Python path for imports
        self.runenv_info.prepend_path("PYTHONPATH", self.package_folder)
        self.runenv_info.prepend_path("PYTHONPATH", os.path.join(self.package_folder, "openssl_base"))

        # PATH for scripts
        self.env_info.PATH.append(os.path.join(self.package_folder, "scripts"))

    def package_id(self):
        """Package ID mode for foundation packages"""
        # Foundation packages should be deterministic
        self.info.clear()

    def validate(self):
        """Validate package configuration"""
        # Foundation packages should work on all platforms
        pass
