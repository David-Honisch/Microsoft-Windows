@echo off
set url=https://releases.ubuntu.com/20.04.6/ubuntu-20.04.6-live-server-amd64.iso
echo RUNNING TEST DOWNLOAD
call LC2DL.exe %url% ubuntu.iso
timeout 3

