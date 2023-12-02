#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit


cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --locked --features pcre2 --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/rg"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"

# Generate + add the man page
mkdir -p "${PREFIX}/share/man/man1"
"$PREFIX/bin/rg" --generate man > "${PREFIX}/share/man/man1/rg.1"
