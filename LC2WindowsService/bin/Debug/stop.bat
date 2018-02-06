@ECHO OFF

REM The following directory is for .NET 2.0
rem set DOTNETFX2=%SystemRoot%\Microsoft.NET\Framework\v2.0.50727
rem set PATH=%PATH%;%DOTNETFX2%
rem echo Installing WindowsService...
 echo ---------------------------------------------------
rem InstallUtil /i %~dp0LC2WindowsService.exe
%~dp0lc2stopservice.exe %~dp0LC2WindowsService.exe
echo ---------------------------------------------------
pause
echo Done.