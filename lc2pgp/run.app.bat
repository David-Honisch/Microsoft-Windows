@echo off
REM call lc2pgp.exe --help
call lc2pgp.exe --generate --message Test --name Test --email david@honisch.org --output generatedkey.key
timeout 3