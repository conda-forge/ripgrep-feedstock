:: build
cargo install --locked  --features pcre2 --root "%PREFIX%" --path . || goto :error

:: strip debug symbols
"%STRIP%" "%PREFIX%\bin\rg.exe" || goto :error

:: remove extra build file
del /F /Q "%PREFIX%\.crates.toml"

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
