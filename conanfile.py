from conan import ConanFile
from conan.tools.cmake import cmake_layout, CMake

class garro(ConanFile):
    name = "garro"
    version = "0.0.1"
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeToolchain', 'CMakeDeps'

    def configure(self):
        self.options["arrow/22.0.0"].parquet = False
        self.options["arrow/22.0.0"].with_boost = False
        self.options["arrow/22.0.0"].with_thrift = False

    def requirements(self):
        self.requires("nlohmann_json/3.12.0")
        self.requires("arrow/22.0.0")
        self.requires("sqlite3/3.51.0")
        self.requires("mcap/2.1.1")

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def layout(self):
        cmake_layout(self)
