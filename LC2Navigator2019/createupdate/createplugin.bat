@echo off
cls
REM .\bin\LC2Logo.exe
echo %time%
REM call zip .\plugins\LC2Logo.exe.zip -9 -r .\plugin\LC2Logo.exe
for %%f in (plugin\*.*) do (
  set /p val=<%%f
  echo fullname: %%f
  REM echo name: %%~nf
  REM echo "contents: !val!"
  call zip .\plugins\%%~nf.zip -9 %%f
  @echo off
)
echo ZIPPING DONE
echo OUTPUT DONE
@echo on