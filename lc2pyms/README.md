# Python Microservices with Authentication

A complete microservices architecture with a centralized authentication service supporting both LDAP and database backends, plus two example client microservices.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Authentication Service                    │
│                      (Port 8000)                            │
│  ┌──────────────┐              ┌──────────────┐            │
│  │   Database   │      OR      │     LDAP     │            │
│  │   Backend    │              │   Backend    │            │
│  └──────────────┘              └──────────────┘            │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ Token Validation
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
┌───────▼────────┐                    ┌────────▼───────┐
│   Service 1    │                    │   Service 2    │
│ User Management│                    │ Data Analytics │
│  (Port 8001)   │                    │  (Port 8002)   │
└────────────────┘                    └────────────────┘
```

## Services

### 1. Authentication Service (`auth_service/`)
- **Port**: 8000
- **Features**:
  - User authentication via LDAP or database
  - Token generation and validation
  - User registration (database backend only)
  - Token revocation (logout)
- **Endpoints**:
  - `POST /api/auth/login` - Authenticate and get token
  - `POST /api/auth/validate` - Validate token
  - `POST /api/auth/logout` - Revoke token
  - `POST /api/auth/register` - Register new user (DB only)
  - `GET /health` - Health check

### 2. User Management Service (`service1/`)
- **Port**: 8001
- **Features**:
  - User profile management
  - Protected endpoints requiring authentication
- **Endpoints**:
  - `GET /api/users/profile` - Get user profile (protected)
  - `PUT /api/users/profile` - Update user profile (protected)
  - `GET /api/users/list` - List all users (protected)
  - `GET /api/public/info` - Public service info
  - `GET /health` - Health check

### 3. Data Analytics Service (`service2/`)
- **Port**: 8002
- **Features**:
  - Analytics dashboard
  - Report generation
  - Data export
- **Endpoints**:
  - `GET /api/analytics/dashboard` - Get dashboard data (protected)
  - `POST /api/analytics/report` - Generate report (protected)
  - `GET /api/analytics/export` - Export data (protected)
  - `POST /api/analytics/refresh` - Refresh data (protected)
  - `GET /api/public/info` - Public service info
  - `GET /health` - Health check

## Installation

### Prerequisites
- Python 3.8 or higher
- pip

### Setup

1. **Install dependencies**:
```bash
pip install -r requirements.txt
```

2. **Configure authentication backend**:

Edit `auth_service/config.yaml` to choose your authentication backend:

**For Database Backend** (default):
```yaml
auth_backend: database

database:
  type: sqlite
  path: auth.db
```

**For LDAP Backend**:
```yaml
auth_backend: ldap

ldap:
  server: ldap://localhost:389
  base_dn: dc=example,dc=com
  user_dn_template: uid={username},ou=users,dc=example,dc=com
  bind_dn: cn=admin,dc=example,dc=com
  bind_password: admin_password
```

## Running the Services

### Start Authentication Service
```bash
cd auth_service
python app.py
```

### Start Service 1 (User Management)
```bash
cd service1
python app.py
```

### Start Service 2 (Data Analytics)
```bash
cd service2
python app.py
```

## Usage Examples

### 1. Register a User (Database Backend Only)
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 2. Login and Get Token
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "password123"
  }'
```

Response:
```json
{
  "success": true,
  "token": "your-token-here",
  "expires_at": "2024-01-01T12:00:00",
  "user": {...}
}
```

### 3. Access Protected Endpoint
```bash
curl -X GET http://localhost:8001/api/users/profile \
  -H "Authorization: Bearer your-token-here"
```

### 4. Update Profile
```bash
curl -X PUT http://localhost:8001/api/users/profile \
  -H "Authorization: Bearer your-token-here" \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "John Doe",
    "role": "developer",
    "department": "Engineering"
  }'
```

### 5. Get Analytics Dashboard
```bash
curl -X GET http://localhost:8002/api/analytics/dashboard \
  -H "Authorization: Bearer your-token-here"
```

### 6. Generate Report
```bash
curl -X POST http://localhost:8002/api/analytics/report \
  -H "Authorization: Bearer your-token-here" \
  -H "Content-Type: application/json" \
  -d '{
    "start_date": "2024-01-01",
    "end_date": "2024-01-07",
    "metrics": ["views", "clicks", "conversions"]
  }'
```

### 7. Logout
```bash
curl -X POST http://localhost:8000/api/auth/logout \
  -H "Content-Type: application/json" \
  -d '{
    "token": "your-token-here"
  }'
```

## Configuration

### Authentication Service Configuration (`auth_service/config.yaml`)

```yaml
# Choose backend: 'ldap' or 'database'
auth_backend: database

# Server settings
server:
  host: 0.0.0.0
  port: 8000
  secret_key: your-secret-key-change-in-production
  token_expiry_minutes: 60

# Database configuration (for database backend)
database:
  type: sqlite  # sqlite, postgresql, mysql
  path: auth.db

# LDAP configuration (for LDAP backend)
ldap:
  server: ldap://localhost:389
  base_dn: dc=example,dc=com
  user_dn_template: uid={username},ou=users,dc=example,dc=com
```

### Environment Variables

Services can be configured via environment variables:

- `AUTH_SERVICE_URL`: URL of the authentication service (default: http://localhost:8000)
- `PORT`: Port for the service to run on

Example:
```bash
export AUTH_SERVICE_URL=http://auth-service:8000
export PORT=8001
python app.py
```

## Security Considerations

1. **Change the secret key** in `config.yaml` for production
2. **Use HTTPS** in production environments
3. **Secure token storage** - tokens should be stored securely on the client side
4. **Token expiration** - configure appropriate token expiry times
5. **LDAP credentials** - store LDAP bind credentials securely
6. **Database credentials** - use environment variables for database passwords

## Testing

### Health Checks
```bash
# Auth service
curl http://localhost:8000/health

# Service 1
curl http://localhost:8001/health

# Service 2
curl http://localhost:8002/health
```

### Create Test User (Database Backend)
```bash
cd auth_service
python -c "
from models import DatabaseManager, User
from datetime import datetime
import yaml

with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

db = DatabaseManager(config)
session = db.get_session()

user = User()
user.username = 'admin'
user.email = 'admin@example.com'
user.set_password('admin123')

session.add(user)
session.commit()
print('Test user created: admin / admin123')
"
```

## Project Structure

```
.
├── auth_service/           # Authentication microservice
│   ├── __init__.py
│   ├── app.py             # Flask application
│   ├── auth_backends.py   # LDAP and DB authentication
│   ├── models.py          # Database models
│   └── config.yaml        # Configuration file
├── service1/              # User Management microservice
│   ├── __init__.py
│   └── app.py
├── service2/              # Data Analytics microservice
│   ├── __init__.py
│   └── app.py
├── shared/                # Shared libraries
│   ├── __init__.py
│   └── auth_client.py     # Authentication client library
├── requirements.txt       # Python dependencies
└── README.md             # This file
```

## Troubleshooting

### Connection Refused
- Ensure the authentication service is running before starting other services
- Check that ports 8000, 8001, 8002 are not in use

### LDAP Connection Issues
- Verify LDAP server is accessible
- Check LDAP configuration in `config.yaml`
- Test LDAP connection with ldapsearch

### Database Issues
- For SQLite: ensure write permissions in the directory
- For PostgreSQL/MySQL: verify connection credentials
- Check database logs for errors

### Token Validation Fails
- Ensure token hasn't expired
- Verify AUTH_SERVICE_URL is correct
- Check authentication service logs

## License

MIT License - feel free to use this in your projects!