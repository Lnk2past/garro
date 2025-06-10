from conan import ConanFile
from conan.tools.cmake import cmake_layout, CMake

class garro(ConanFile):
    name = "garro"
    version = "0.0.1"
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeToolchain', 'CMakeDeps'

    def requirements(self):
        self.requires("fmt/11.1.1")
        self.requires("nlohmann_json/3.11.3")
        self.requires("arrow/19.0.1")
        self.requires("sqlite3/3.49.1")

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def layout(self):
        cmake_layout(self)
