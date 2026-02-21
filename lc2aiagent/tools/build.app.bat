@echo off
REM call pyinstaller app.py c
REM call python -m pip install PyInstaller
call python -m PyInstaller tools\list_hugging_face_models.py  --onefile
REM call python -m PyInstaller app.py --onefile
copy dist\app.exe app.exe
