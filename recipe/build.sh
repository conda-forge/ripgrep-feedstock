#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ "$target_platform" == osx* ]]; then
  ln -s $(which $CC) $BUILD_PREFIX/bin/cc
  if [[ "$target_platform" == osx-arm64 ]]; then
    export CFLAGS="$CFLAGS -arch arm64"
    export CPPFLAGS="$CPPFLAGS -arch arm64"
    export CXXFLAGS="$CXXFLAGS -arch arm64"
  fi
fi

# build statically linked binary with Rust
cargo install --locked --features pcre2 --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/rg"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"
