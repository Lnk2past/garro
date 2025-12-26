#! /usr/bin/bash

set -e

apt update && apt install cmake gdb pipx -y

pipx install conan && conan config install .devcontainer/.conan/ -tf profiles
