# Python Microservices Architecture - Project Overview

## 🎯 Project Summary

A complete, production-ready microservices architecture featuring:
- **Centralized Authentication Service** with LDAP and Database backend support
- **Two Example Client Microservices** demonstrating authentication integration
- **Shared Authentication Client Library** for easy integration
- **Comprehensive Documentation** and testing tools

## 📁 Project Structure

```
pyms/
├── auth_service/              # Authentication Microservice
│   ├── __init__.py
│   ├── app.py                # Flask application & API endpoints
│   ├── auth_backends.py      # LDAP & Database authentication backends
│   ├── models.py             # SQLAlchemy database models
│   └── config.yaml           # Service configuration
│
├── service1/                  # User Management Microservice
│   ├── __init__.py
│   └── app.py                # User profile management service
│
├── service2/                  # Data Analytics Microservice
│   ├── __init__.py
│   └── app.py                # Analytics and reporting service
│
├── shared/                    # Shared Libraries
│   ├── __init__.py
│   └── auth_client.py        # Authentication client library
│
├── examples/                  # Usage Examples
│   ├── __init__.py
│   └── example_usage.py      # Code examples
│
├── requirements.txt           # Python dependencies
├── .gitignore                # Git ignore rules
├── docker-compose.yml        # Docker orchestration
├── start_services.bat        # Windows startup script
├── start_services.sh         # Unix/Linux/Mac startup script
├── test_setup.py             # Automated test suite
├── README.md                 # Full documentation
├── QUICKSTART.md             # Quick start guide
└── PROJECT_OVERVIEW.md       # This file
```

## 🔑 Key Features

### Authentication Service
- ✅ **Dual Backend Support**: Switch between LDAP and Database authentication via configuration
- ✅ **Token-Based Authentication**: Secure JWT-like token generation and validation
- ✅ **User Registration**: Built-in user registration for database backend
- ✅ **Token Management**: Token creation, validation, and revocation
- ✅ **Configurable Expiry**: Customizable token expiration times
- ✅ **Health Checks**: Built-in health monitoring endpoints

### Client Services
- ✅ **Service 1 (User Management)**: Profile management, user listing
- ✅ **Service 2 (Data Analytics)**: Dashboard, reporting, data export
- ✅ **Protected Endpoints**: Decorator-based authentication enforcement
- ✅ **Public Endpoints**: Mix of public and protected routes
- ✅ **Error Handling**: Comprehensive error responses

### Shared Library
- ✅ **Easy Integration**: Simple API for authentication operations
- ✅ **Flask Decorator**: `@require_auth` decorator for protecting routes
- ✅ **Token Management**: Login, logout, validation methods
- ✅ **Health Checks**: Service availability monitoring

## 🚀 Quick Start

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Start Services

**Windows:**
```cmd
start_services.bat
```

**Linux/Mac:**
```bash
chmod +x start_services.sh
./start_services.sh
```

### 3. Test the Setup
```bash
python test_setup.py
```

## 📊 Service Ports

| Service | Port | Description |
|---------|------|-------------|
| Authentication | 8000 | Central auth service |
| Service 1 | 8001 | User Management |
| Service 2 | 8002 | Data Analytics |

## 🔐 Authentication Flow

```
1. Client → Auth Service: POST /api/auth/login
   ↓
2. Auth Service validates credentials (LDAP or DB)
   ↓
3. Auth Service ← Token generated
   ↓
4. Client ← Token returned
   ↓
5. Client → Service 1/2: GET /api/protected (with token)
   ↓
6. Service 1/2 → Auth Service: Validate token
   ↓
7. Auth Service ← Token valid + username
   ↓
8. Service 1/2 ← Process request
   ↓
9. Client ← Response
```

## 🛠️ Configuration

### Authentication Backend Selection

Edit `auth_service/config.yaml`:

**Database Mode (Default):**
```yaml
auth_backend: database
database:
  type: sqlite
  path: auth.db
```

**LDAP Mode:**
```yaml
auth_backend: ldap
ldap:
  server: ldap://localhost:389
  base_dn: dc=example,dc=com
  user_dn_template: uid={username},ou=users,dc=example,dc=com
```

## 📝 API Endpoints

### Authentication Service (Port 8000)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/login` | Login and get token | No |
| POST | `/api/auth/register` | Register new user (DB only) | No |
| POST | `/api/auth/validate` | Validate token | No |
| POST | `/api/auth/logout` | Revoke token | No |
| GET | `/health` | Health check | No |

### Service 1 - User Management (Port 8001)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/users/profile` | Get user profile | Yes |
| PUT | `/api/users/profile` | Update profile | Yes |
| GET | `/api/users/list` | List all users | Yes |
| GET | `/api/public/info` | Service info | No |
| GET | `/health` | Health check | No |

### Service 2 - Data Analytics (Port 8002)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/analytics/dashboard` | Get dashboard | Yes |
| POST | `/api/analytics/report` | Generate report | Yes |
| GET | `/api/analytics/export` | Export data | Yes |
| POST | `/api/analytics/refresh` | Refresh data | Yes |
| GET | `/api/public/info` | Service info | No |
| GET | `/health` | Health check | No |

## 🧪 Testing

### Automated Tests
```bash
python test_setup.py
```

Tests include:
- ✅ Health checks for all services
- ✅ User registration
- ✅ Login and token generation
- ✅ Token validation
- ✅ Protected endpoint access
- ✅ Unauthorized access rejection

### Manual Testing

**1. Register User:**
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"pass123"}'
```

**2. Login:**
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"pass123"}'
```

**3. Access Protected Endpoint:**
```bash
curl -X GET http://localhost:8001/api/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 🔧 Technology Stack

- **Framework**: Flask 3.0.0
- **Database ORM**: SQLAlchemy 2.0.23
- **LDAP**: ldap3 2.9.1
- **Password Hashing**: bcrypt 4.1.2
- **HTTP Client**: requests 2.31.0
- **Configuration**: PyYAML 6.0.1
- **CORS**: flask-cors 4.0.0

## 📦 Dependencies

All dependencies are listed in `requirements.txt`:
- Core web framework (Flask)
- Database support (SQLAlchemy, bcrypt)
- LDAP support (ldap3)
- HTTP client (requests)
- Configuration (PyYAML)
- CORS support (flask-cors)

Optional database drivers:
- PostgreSQL: psycopg2-binary
- MySQL: pymysql

## 🐳 Docker Support

Use Docker Compose to run all services:

```bash
docker-compose up
```

This will start all three services in containers with proper networking.

## 🔒 Security Considerations

1. **Change Secret Key**: Update `secret_key` in `config.yaml` for production
2. **Use HTTPS**: Always use HTTPS in production environments
3. **Secure Token Storage**: Store tokens securely on client side
4. **Token Expiration**: Configure appropriate expiry times
5. **Environment Variables**: Use env vars for sensitive data
6. **LDAP Credentials**: Secure LDAP bind credentials
7. **Database Passwords**: Never commit passwords to version control

## 📚 Documentation Files

- **README.md**: Complete documentation with examples
- **QUICKSTART.md**: Get started in 5 minutes
- **PROJECT_OVERVIEW.md**: This file - architecture overview
- **Code Comments**: Extensive inline documentation

## 🎓 Learning Resources

### For Beginners
1. Start with QUICKSTART.md
2. Run the automated tests
3. Try the example curl commands
4. Explore examples/example_usage.py

### For Developers
1. Read the full README.md
2. Study the authentication flow
3. Review auth_client.py for integration patterns
4. Examine service1/app.py and service2/app.py for implementation examples

### For DevOps
1. Review docker-compose.yml
2. Check configuration options in config.yaml
3. Understand the startup scripts
4. Review health check endpoints

## 🚀 Extending the System

### Adding a New Microservice

1. Create a new directory (e.g., `service3/`)
2. Create `app.py` with Flask application
3. Import and use `AuthClient` from `shared/auth_client.py`
4. Use `@require_auth` decorator for protected endpoints
5. Add to startup scripts

Example:
```python
from shared.auth_client import AuthClient, require_auth

auth_client = AuthClient("http://localhost:8000")

@app.route('/api/protected')
@require_auth(auth_client)
def protected_route(username):
    return f"Hello {username}"
```

## 🐛 Troubleshooting

### Common Issues

**Port Already in Use:**
- Check if services are already running
- Use different ports via environment variables

**Module Not Found:**
- Run `pip install -r requirements.txt`
- Ensure Python 3.8+ is installed

**Connection Refused:**
- Start auth service first (port 8000)
- Check firewall settings
- Verify service URLs in configuration

**LDAP Connection Failed:**
- Verify LDAP server is accessible
- Check LDAP configuration in config.yaml
- Test with ldapsearch command

## 📈 Performance Considerations

- **Token Caching**: Consider Redis for token storage in production
- **Database Connection Pooling**: Configure SQLAlchemy pool settings
- **Load Balancing**: Use nginx or similar for multiple instances
- **Monitoring**: Add logging and metrics collection
- **Rate Limiting**: Implement rate limiting for API endpoints

## 🤝 Contributing

This is a template project. Feel free to:
- Add new features
- Improve documentation
- Add more examples
- Enhance security
- Optimize performance

## 📄 License

MIT License - Free to use in your projects!

## 🎉 Summary

You now have a complete, working microservices architecture with:
- ✅ Centralized authentication
- ✅ Multiple backend support (LDAP/Database)
- ✅ Two example client services
- ✅ Shared authentication library
- ✅ Comprehensive documentation
- ✅ Testing tools
- ✅ Startup scripts
- ✅ Docker support

Ready to build your microservices! 🚀