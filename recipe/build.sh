#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export PCRE2_SYS_STATIC=1
# Rust links with -nodefaultlibs, so explicitly include the startup helpers
# required by the oldest Linux sysroot.
if [[ "${target_platform}" == linux-* ]]; then
    export CARGO_BUILD_RUSTFLAGS="${CARGO_BUILD_RUSTFLAGS:-} -C link-arg=${CONDA_BUILD_SYSROOT}/usr/lib64/libc_nonshared.a"
fi

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --no-track --locked --features pcre2 --root "$PREFIX" --path .

# Generate + add the man page
mkdir -p "${PREFIX}/share/man/man1"
"$PREFIX/bin/rg" --generate man > "${PREFIX}/share/man/man1/rg.1" || true

# Generate + add completion files
mkdir -p "${PREFIX}/etc/bash_completion.d"
"$PREFIX/bin/rg" --generate complete-bash > "${PREFIX}/etc/bash_completion.d/rg" || true
mkdir -p "${PREFIX}/share/zsh/site-functions"
"$PREFIX/bin/rg" --generate complete-zsh > "${PREFIX}/share/zsh/site-functions/_rg" || true
