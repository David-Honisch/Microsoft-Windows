"""
Authentication Microservice
Supports both LDAP and Database authentication backends
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
import yaml
import logging
from auth_backends import get_auth_backend

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load configuration
with open('config.yaml', 'r') as f:
    config = yaml.safe_load(f)

# Configure logging
logging.basicConfig(
    level=getattr(logging, config['logging']['level']),
    format=config['logging']['format']
)
logger = logging.getLogger(__name__)

# Initialize authentication backend
auth_backend = get_auth_backend(config)

# Set secret key for session management
app.config['SECRET_KEY'] = config['server']['secret_key']


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'authentication',
        'backend': config['auth_backend']
    }), 200


@app.route('/api/auth/login', methods=['POST'])
def login():
    """
    Authenticate user and return token
    Request body: {"username": "user", "password": "pass"}
    """
    try:
        data = request.get_json()
        
        if not data or 'username' not in data or 'password' not in data:
            return jsonify({'error': 'Username and password required'}), 400
        
        username = data['username']
        password = data['password']
        
        # Authenticate user
        success, user_info = auth_backend.authenticate(username, password)
        
        if success:
            # Create token
            token_data = auth_backend.create_token(username)
            
            if token_data:
                return jsonify({
                    'success': True,
                    'token': token_data['token'],
                    'expires_at': token_data['expires_at'],
                    'user': user_info
                }), 200
            else:
                return jsonify({'error': 'Failed to create token'}), 500
        else:
            return jsonify({'error': 'Invalid credentials'}), 401
    
    except Exception as e:
        logger.error(f"Login error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/auth/validate', methods=['POST'])
def validate():
    """
    Validate authentication token
    Request body: {"token": "token_string"}
    """
    try:
        data = request.get_json()
        
        if not data or 'token' not in data:
            return jsonify({'error': 'Token required'}), 400
        
        token = data['token']
        
        # Validate token
        valid, username = auth_backend.validate_token(token)
        
        if valid:
            return jsonify({
                'valid': True,
                'username': username
            }), 200
        else:
            return jsonify({
                'valid': False,
                'error': 'Invalid or expired token'
            }), 401
    
    except Exception as e:
        logger.error(f"Validation error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/auth/logout', methods=['POST'])
def logout():
    """
    Revoke authentication token
    Request body: {"token": "token_string"}
    """
    try:
        data = request.get_json()
        
        if not data or 'token' not in data:
            return jsonify({'error': 'Token required'}), 400
        
        token = data['token']
        
        # Revoke token
        success = auth_backend.revoke_token(token)
        
        if success:
            return jsonify({'success': True, 'message': 'Logged out successfully'}), 200
        else:
            return jsonify({'error': 'Token not found'}), 404
    
    except Exception as e:
        logger.error(f"Logout error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/auth/register', methods=['POST'])
def register():
    """
    Register new user (only for database backend)
    Request body: {"username": "user", "email": "user@example.com", "password": "pass"}
    """
    try:
        if config['auth_backend'] != 'database':
            return jsonify({'error': 'Registration only available for database backend'}), 400
        
        data = request.get_json()
        
        if not data or 'username' not in data or 'email' not in data or 'password' not in data:
            return jsonify({'error': 'Username, email, and password required'}), 400
        
        username = data['username']
        email = data['email']
        password = data['password']
        
        # Create user
        success, result = auth_backend.create_user(username, email, password)
        
        if success:
            return jsonify({
                'success': True,
                'message': 'User registered successfully',
                'user': result
            }), 201
        else:
            return jsonify({'error': result}), 400
    
    except Exception as e:
        logger.error(f"Registration error: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({'error': 'Endpoint not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    host = config['server']['host']
    port = config['server']['port']
    
    logger.info(f"Starting authentication service on {host}:{port}")
    logger.info(f"Using {config['auth_backend']} authentication backend")
    
    app.run(host=host, port=port, debug=False)