@echo off
call LC2CRC32CLI.exe "C:\tools\LC2CRC\LC2CRC32CLI.exe" 1f943296 -validate
call LC2CRC32CLI.exe "C:\tools\LC2CRC\LC2CRC.exe" 1f943296 -validate
call LC2CRC32CLI.exe "C:\tools\LC2CRC\LC2CRC.exe" 21f943296 -validate