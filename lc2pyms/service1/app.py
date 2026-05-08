"""
Service 1 - User Management Microservice
Demonstrates authentication integration with protected endpoints
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
import sys
import os
import logging

# Add parent directory to path to import shared module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from shared.auth_client import AuthClient, require_auth, get_token_from_request

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize auth client
AUTH_SERVICE_URL = os.environ.get('AUTH_SERVICE_URL', 'http://localhost:8000')
auth_client = AuthClient(AUTH_SERVICE_URL)

# In-memory user data store (for demonstration)
users_data = {
    'admin': {
        'profile': {
            'full_name': 'Admin User',
            'role': 'administrator',
            'department': 'IT'
        }
    },
    'user1': {
        'profile': {
            'full_name': 'John Doe',
            'role': 'developer',
            'department': 'Engineering'
        }
    }
}


@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    auth_healthy = auth_client.health_check()
    return jsonify({
        'status': 'healthy',
        'service': 'user-management',
        'auth_service': 'connected' if auth_healthy else 'disconnected'
    }), 200


@app.route('/api/users/profile', methods=['GET'])
@require_auth(auth_client)
def get_profile(username):
    """
    Get user profile (protected endpoint)
    Requires: Authorization: Bearer <token>
    """
    try:
        if username in users_data:
            profile = users_data[username]['profile']
            return jsonify({
                'username': username,
                'profile': profile
            }), 200
        else:
            # Return basic profile for authenticated users not in our data store
            return jsonify({
                'username': username,
                'profile': {
                    'full_name': username.title(),
                    'role': 'user',
                    'department': 'General'
                }
            }), 200
    except Exception as e:
        logger.error(f"Error getting profile: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/users/profile', methods=['PUT'])
@require_auth(auth_client)
def update_profile(username):
    """
    Update user profile (protected endpoint)
    Requires: Authorization: Bearer <token>
    Request body: {"full_name": "...", "role": "...", "department": "..."}
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Initialize user data if not exists
        if username not in users_data:
            users_data[username] = {'profile': {}}
        
        # Update profile fields
        profile = users_data[username]['profile']
        if 'full_name' in data:
            profile['full_name'] = data['full_name']
        if 'role' in data:
            profile['role'] = data['role']
        if 'department' in data:
            profile['department'] = data['department']
        
        return jsonify({
            'success': True,
            'message': 'Profile updated successfully',
            'profile': profile
        }), 200
    
    except Exception as e:
        logger.error(f"Error updating profile: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/users/list', methods=['GET'])
@require_auth(auth_client)
def list_users(username):
    """
    List all users (protected endpoint)
    Requires: Authorization: Bearer <token>
    """
    try:
        user_list = []
        for user, data in users_data.items():
            user_list.append({
                'username': user,
                'full_name': data['profile'].get('full_name', user),
                'role': data['profile'].get('role', 'user'),
                'department': data['profile'].get('department', 'General')
            })
        
        return jsonify({
            'users': user_list,
            'count': len(user_list),
            'requested_by': username
        }), 200
    
    except Exception as e:
        logger.error(f"Error listing users: {e}")
        return jsonify({'error': 'Internal server error'}), 500


@app.route('/api/public/info', methods=['GET'])
def public_info():
    """Public endpoint (no authentication required)"""
    return jsonify({
        'service': 'User Management Service',
        'version': '1.0.0',
        'description': 'Manages user profiles and information',
        'endpoints': {
            'public': ['/health', '/api/public/info'],
            'protected': ['/api/users/profile', '/api/users/list']
        }
    }), 200


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({'error': 'Endpoint not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8001))
    logger.info(f"Starting User Management Service on port {port}")
    logger.info(f"Auth service URL: {AUTH_SERVICE_URL}")
    app.run(host='0.0.0.0', port=port, debug=False)
