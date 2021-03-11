@echo off
set importfile=import.csv
dir /b /s python > %importfile%
import.files.from.csv.to.sqlite.bat %importfile% pythonplugin
@echo on