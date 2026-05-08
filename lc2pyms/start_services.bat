@echo off
REM Windows batch script to start all microservices

echo Starting Python Microservices...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM Install dependencies if needed
echo Checking dependencies...
pip show flask >nul 2>&1
if errorlevel 1 (
    echo Installing dependencies...
    pip install -r requirements.txt
)

echo.
echo Starting services...
echo.

REM Start Authentication Service
echo Starting Authentication Service on port 8000...
start "Auth Service" cmd /k "cd auth_service && python app.py"
timeout /t 3 /nobreak >nul

REM Start Service 1
echo Starting User Management Service on port 8001...
start "Service 1" cmd /k "cd service1 && python app.py"
timeout /t 2 /nobreak >nul

REM Start Service 2
echo Starting Data Analytics Service on port 8002...
start "Service 2" cmd /k "cd service2 && python app.py"

echo.
echo All services started!
echo.
echo Services:
echo - Auth Service:     http://localhost:8000
echo - Service 1:        http://localhost:8001
echo - Service 2:        http://localhost:8002
echo.
echo Press any key to run tests...
pause >nul

REM Run tests
python test_setup.py

echo.
echo Press any key to exit...
pause >nul