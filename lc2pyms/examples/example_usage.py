"""
Example usage of the authentication client library
Demonstrates how to integrate authentication into your own microservices
"""
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from shared.auth_client import AuthClient

# Initialize the auth client
auth_client = AuthClient("http://localhost:8000")

def example_login():
    """Example: Login and get token"""
    print("=== Login Example ===")
    
    success, response = auth_client.login("testuser", "testpass123")
    
    if success:
        token = response['token']
        print(f"Login successful!")
        print(f"Token: {token}")
        print(f"Expires at: {response['expires_at']}")
        return token
    else:
        print(f"Login failed: {response}")
        return None


def example_validate_token(token):
    """Example: Validate a token"""
    print("\n=== Token Validation Example ===")
    
    valid, username = auth_client.validate_token(token)
    
    if valid:
        print(f"Token is valid for user: {username}")
        return True
    else:
        print("Token is invalid or expired")
        return False


def example_register():
    """Example: Register a new user"""
    print("\n=== Registration Example ===")
    
    success, response = auth_client.register(
        username="newuser",
        email="newuser@example.com",
        password="newpass123"
    )
    
    if success:
        print("Registration successful!")
        print(f"User: {response['user']}")
    else:
        print(f"Registration failed: {response}")


def example_logout(token):
    """Example: Logout and revoke token"""
    print("\n=== Logout Example ===")
    
    success = auth_client.logout(token)
    
    if success:
        print("Logout successful, token revoked")
    else:
        print("Logout failed")


def example_protected_request(token):
    """Example: Make a request to a protected endpoint"""
    print("\n=== Protected Request Example ===")
    
    import requests
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # Request to Service 1
    response = requests.get(
        "http://localhost:8001/api/users/profile",
        headers=headers
    )
    
    if response.status_code == 200:
        print("Protected endpoint accessed successfully!")
        print(f"Response: {response.json()}")
    else:
        print(f"Failed to access protected endpoint: {response.status_code}")


def example_flask_integration():
    """Example: How to use the decorator in Flask"""
    print("\n=== Flask Integration Example ===")
    print("""
from flask import Flask
from shared.auth_client import AuthClient, require_auth

app = Flask(__name__)
auth_client = AuthClient("http://localhost:8000")

@app.route('/protected')
@require_auth(auth_client)
def protected_route(username):
    return f"Hello {username}, you are authenticated!"

# Client makes request with:
# Authorization: Bearer <token>
    """)


def main():
    """Run all examples"""
    print("=" * 60)
    print("Authentication Client Library - Usage Examples")
    print("=" * 60)
    
    # Check if auth service is available
    if not auth_client.health_check():
        print("\nError: Authentication service is not available")
        print("Please start the auth service first: cd auth_service && python app.py")
        return
    
    print("\nAuth service is healthy!\n")
    
    # Example 1: Register a user
    example_register()
    
    # Example 2: Login
    token = example_login()
    
    if token:
        # Example 3: Validate token
        example_validate_token(token)
        
        # Example 4: Make protected request
        example_protected_request(token)
        
        # Example 5: Logout
        example_logout(token)
        
        # Example 6: Verify token is revoked
        example_validate_token(token)
    
    # Example 7: Show Flask integration
    example_flask_integration()
    
    print("\n" + "=" * 60)
    print("Examples completed!")
    print("=" * 60)


if __name__ == "__main__":
    main()