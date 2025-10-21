from conan import ConanFile
from conan.tools.files import copy
import os

class OpenSSLBaseConan(ConanFile):
    name = "openssl-base"
    version = "1.0.0"
    description = "Foundation: profiles and Python runtime"
    license = "Apache-2.0"
    url = "https://github.com/sparesparrow/openssl-conan-base"
    package_type = "header-library"
    settings = None
    python_requires = "openssl-tools/[*]@sparesparrow-conan/openssl-conan"
    python_requires_extend = "openssl-tools.OpenSSLTools"
    exports_sources = "openssl_base/*", "profiles/*", "python_env/*"

    def package(self):
        copy(self, "*.profile", src=os.path.join(self.source_folder, "profiles"), dst=os.path.join(self.package_folder, "profiles"), keep_path=True)

    def package_info(self):
        self.cpp_info.bindirs = []
        self.cpp_info.libdirs = []
        self.runenv_info.define("OPENSSL_PROFILES_PATH", os.path.join(self.package_folder, "profiles"))
