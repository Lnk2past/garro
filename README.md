# garro

This is an educational endeavor into learning a bit more about serialization techniques and formats using C++23. Some goals, which will absolutely change as I experiement and mess around with it all:

* Class(es) for defining tabular structures with different serialization backends
    * CSV
    * Apache Arrow/Parquet, with optional DuckDB backend
    * PostgreSQL
    * HDF5 (maybe?)
    * Other formats?
* I want to be able to define tables at compile-time with fixed types
* How can we maximize performance? Minimize copies?

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
