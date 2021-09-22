#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit


if command -v cargo-bundle-licenses &> /dev/null; then
    cargo-bundle-licenses \
        --format yaml \
        --output CI.THIRDPARTY.yml \
        --previous "${RECIPE_DIR}/THIRDPARTY.yml" \
        --check-previous
fi

# build statically linked binary with Rust
cargo install --locked --features pcre2 --root "$PREFIX" --path .

# strip debug symbols
"$STRIP" "$PREFIX/bin/rg"

# remove extra build file
rm -f "${PREFIX}/.crates.toml"
