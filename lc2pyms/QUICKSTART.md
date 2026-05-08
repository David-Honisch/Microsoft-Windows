# Quick Start Guide

Get the microservices up and running in 5 minutes!

## Prerequisites

- Python 3.8 or higher
- pip (Python package installer)

## Quick Setup

### Windows

1. **Install dependencies**:
```cmd
pip install -r requirements.txt
```

2. **Start all services**:
```cmd
start_services.bat
```

This will:
- Start the Authentication Service on port 8000
- Start Service 1 (User Management) on port 8001
- Start Service 2 (Data Analytics) on port 8002
- Run automated tests

### Linux/Mac

1. **Install dependencies**:
```bash
pip3 install -r requirements.txt
```

2. **Make the script executable**:
```bash
chmod +x start_services.sh
```

3. **Start all services**:
```bash
./start_services.sh
```

Press Ctrl+C to stop all services.

## Manual Start (Alternative)

If you prefer to start services manually:

### Terminal 1 - Authentication Service
```bash
cd auth_service
python app.py
```

### Terminal 2 - Service 1
```bash
cd service1
python app.py
```

### Terminal 3 - Service 2
```bash
cd service2
python app.py
```

## Test the Setup

Run the test suite:
```bash
python test_setup.py
```

## Try It Out

### 1. Register a User
```bash
curl -X POST http://localhost:8000/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"demo\",\"email\":\"demo@example.com\",\"password\":\"demo123\"}"
```

### 2. Login
```bash
curl -X POST http://localhost:8000/api/auth/login ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"demo\",\"password\":\"demo123\"}"
```

Save the token from the response!

### 3. Access Protected Endpoint
```bash
curl -X GET http://localhost:8001/api/users/profile ^
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 4. Get Analytics Dashboard
```bash
curl -X GET http://localhost:8002/api/analytics/dashboard ^
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Configuration

The authentication backend is configured in `auth_service/config.yaml`:

- **Database mode** (default): Uses SQLite for user storage
- **LDAP mode**: Authenticates against an LDAP server

To switch to LDAP:
1. Edit `auth_service/config.yaml`
2. Change `auth_backend: database` to `auth_backend: ldap`
3. Configure LDAP settings
4. Restart the auth service

## Troubleshooting

### Port Already in Use
If you get "port already in use" errors:
- Windows: `netstat -ano | findstr :8000` then `taskkill /PID <PID> /F`
- Linux/Mac: `lsof -ti:8000 | xargs kill -9`

### Module Not Found
```bash
pip install -r requirements.txt
```

### Services Can't Connect
Make sure the authentication service (port 8000) is running before starting other services.

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Explore the API endpoints
- Customize the services for your needs
- Add more microservices using the same pattern

## Architecture Overview

```
┌─────────────────┐
│  Auth Service   │ ← Handles authentication
│   Port 8000     │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
┌───▼───┐ ┌──▼────┐
│Service│ │Service│ ← Client services
│   1   │ │   2   │    validate tokens
│ 8001  │ │ 8002  │
└───────┘ └───────┘
```

## Support

For issues or questions, check the main README.md or review the code comments.