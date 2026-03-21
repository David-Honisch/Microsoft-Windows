@echo off
call go build -o bin/lc2packer.exe ./cmd/packer
call go build -o bin/lc2loader.exe ./cmd/loader