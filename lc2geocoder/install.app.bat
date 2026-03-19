@echo off
set dllist=dl_bin.csv
for /f "usebackq tokens=1-5 delims=;" %%a in ("%dllist%") do (
	call lc2dl --source %%a --target %%~na.%%~xa
)