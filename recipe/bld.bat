@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
set CARGO_EXTRA_ARGS=
if %target_platform% neq %build_platform% (
  if %target_platform%==win-arm64 (
    set CARGO_EXTRA_ARGS=--target aarch64-pc-windows-msvc
  )
  if %target_platform%==win-64 (
    set CARGO_EXTRA_ARGS=--target x86_64-pc-windows-msvc
  )
)

:: build
cargo install --locked ^
    --root "%PREFIX%" ^
    --path . ^
    --features pcre2 ^
    --no-track ^
    %CARGO_EXTRA_ARGS% ^
    || exit 1

:: dump licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 1
