"""
Authentication Client Library
Shared library for microservices to authenticate against the auth service
"""
import requests
import logging
from typing import Optional, Tuple
from functools import wraps
from flask import request, jsonify

logger = logging.getLogger(__name__)


class AuthClient:
    """Client for interacting with the authentication service"""
    
    def __init__(self, auth_service_url: str):
        """
        Initialize auth client
        
        Args:
            auth_service_url: Base URL of the authentication service (e.g., http://localhost:8000)
        """
        self.auth_service_url = auth_service_url.rstrip('/')
        self.session = requests.Session()
    
    def login(self, username: str, password: str) -> Tuple[bool, Optional[dict]]:
        """
        Authenticate user and get token
        
        Args:
            username: Username
            password: Password
        
        Returns:
            Tuple of (success, response_data)
        """
        try:
            response = self.session.post(
                f"{self.auth_service_url}/api/auth/login",
                json={'username': username, 'password': password},
                timeout=5
            )
            
            if response.status_code == 200:
                data = response.json()
                logger.info(f"Login successful for user {username}")
                return True, data
            else:
                logger.warning(f"Login failed for user {username}: {response.status_code}")
                return False, response.json() if response.text else None
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Login request failed: {e}")
            return False, None
    
    def validate_token(self, token: str) -> Tuple[bool, Optional[str]]:
        """
        Validate authentication token
        
        Args:
            token: Authentication token
        
        Returns:
            Tuple of (valid, username)
        """
        try:
            response = self.session.post(
                f"{self.auth_service_url}/api/auth/validate",
                json={'token': token},
                timeout=5
            )
            
            if response.status_code == 200:
                data = response.json()
                if data.get('valid'):
                    username = data.get('username')
                    logger.info(f"Token validated for user {username}")
                    return True, username
            
            logger.warning("Token validation failed")
            return False, None
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Token validation request failed: {e}")
            return False, None
    
    def logout(self, token: str) -> bool:
        """
        Logout and revoke token
        
        Args:
            token: Authentication token
        
        Returns:
            Success status
        """
        try:
            response = self.session.post(
                f"{self.auth_service_url}/api/auth/logout",
                json={'token': token},
                timeout=5
            )
            
            if response.status_code == 200:
                logger.info("Logout successful")
                return True
            
            logger.warning(f"Logout failed: {response.status_code}")
            return False
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Logout request failed: {e}")
            return False
    
    def register(self, username: str, email: str, password: str) -> Tuple[bool, Optional[dict]]:
        """
        Register new user (only for database backend)
        
        Args:
            username: Username
            email: Email address
            password: Password
        
        Returns:
            Tuple of (success, response_data)
        """
        try:
            response = self.session.post(
                f"{self.auth_service_url}/api/auth/register",
                json={'username': username, 'email': email, 'password': password},
                timeout=5
            )
            
            if response.status_code == 201:
                data = response.json()
                logger.info(f"User {username} registered successfully")
                return True, data
            else:
                logger.warning(f"Registration failed: {response.status_code}")
                return False, response.json() if response.text else None
        
        except requests.exceptions.RequestException as e:
            logger.error(f"Registration request failed: {e}")
            return False, None
    
    def health_check(self) -> bool:
        """
        Check if authentication service is healthy
        
        Returns:
            Health status
        """
        try:
            response = self.session.get(
                f"{self.auth_service_url}/health",
                timeout=5
            )
            return response.status_code == 200
        except requests.exceptions.RequestException as e:
            logger.error(f"Health check failed: {e}")
            return False


def require_auth(auth_client: AuthClient):
    """
    Decorator to require authentication for Flask routes
    
    Usage:
        @app.route('/protected')
        @require_auth(auth_client)
        def protected_route(username):
            return f"Hello {username}"
    
    Args:
        auth_client: AuthClient instance
    """
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            # Get token from Authorization header
            auth_header = request.headers.get('Authorization')
            
            if not auth_header:
                return jsonify({'error': 'No authorization header'}), 401
            
            # Extract token (format: "Bearer <token>")
            parts = auth_header.split()
            if len(parts) != 2 or parts[0].lower() != 'bearer':
                return jsonify({'error': 'Invalid authorization header format'}), 401
            
            token = parts[1]
            
            # Validate token
            valid, username = auth_client.validate_token(token)
            
            if not valid:
                return jsonify({'error': 'Invalid or expired token'}), 401
            
            # Pass username to the route function
            return f(username=username, *args, **kwargs)
        
        return decorated_function
    return decorator


def get_token_from_request() -> Optional[str]:
    """
    Extract token from request Authorization header
    
    Returns:
        Token string or None
    """
    auth_header = request.headers.get('Authorization')
    
    if not auth_header:
        return None
    
    parts = auth_header.split()
    if len(parts) != 2 or parts[0].lower() != 'bearer':
        return None
    
    return parts[1]
