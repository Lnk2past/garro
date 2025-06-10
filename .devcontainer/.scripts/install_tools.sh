#! /usr/bin/bash

set -e

apt update && apt install cmake gdb pipx -y

pipx install conan && conan config install .devcontainer/.conan/ -tf profiles

SLANG_VERSION=2025.3.1
curl -OL https://github.com/shader-slang/slang/releases/download/v${SLANG_VERSION}/slang-${SLANG_VERSION}-linux-x86_64.tar.gz
tar -xvzf slang-${SLANG_VERSION}-linux-x86_64.tar.gz -C /usr/local/ bin cmake include lib share
rm slang-${SLANG_VERSION}-linux-x86_64.tar.gz
