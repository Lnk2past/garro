# garro

This is an educational endeavor into learning a bit more about OpenGL and compute shaders using C++20. Some goals, which will absolutely change as I experiement and mess around with it all:

* Classes/wrappers for defining compute shaders
    * I want to be able to create a shader object and interface with that object for compiling, loading data, creating buffers, reading from buffers, etc.
    * Ideally would be able to template types as much as I can
        * Unclear how to do this in GLSL yet
* Learn about and integrate [shader-slang](https://shader-slang.org/)
* Who knows? I don't know anything about this stuff yet, so I don't know what I don't know yet.

<center><img src="garro.png" width="120"></center>

## Development

Devcontainer provided; just launch a Codespace or local devcontainer!

### Build

This project uses Conan + CMake for dependency management and builds. You will need to install dependencies via Conan and then build via CMake (there are VSCode build tasks for these!):

```shell
# install dependencies
conan install . --build=missing

# load preset
cmake --preset conan-release

# build code
cmake --build --preset conan-release
```

## Examples

Check out [`examples`](./examples) for some basic usage. Need to script building these...
