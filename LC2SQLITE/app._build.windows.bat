@echo off
rem call electron-packager .
rem call electron-packager . lc2search --overwrite --asar=true --platform=win32 --arch=ia32 --icon=./favicon.ico --prune=true --out=release-builds --version-string.CompanyName=CE --version-string.FileDescription=CE --version-string.ProductName="LC2PostApp"
call npm run package-win
pause
@echo on