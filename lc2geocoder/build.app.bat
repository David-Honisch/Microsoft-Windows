@echo off
set RUST_BACKTRACE=1
REM call .\server\target\release\query-server output-dir [bind-address]cal
REM # Start with automatic HTTPS
call cargo build --release --manifest-path server\Cargo.toml