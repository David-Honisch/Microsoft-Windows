@echo off
setlocal enabledelayedexpansion
rem Create the joblist.csv file
echo filename> joblist.csv
rem Loop through all files in the current directory and append their names to joblist.csv
for %%f in (*) do (
echo "%%f" >> joblist.csv
)
echo joblist.csv has been created with filenames from the current directory.