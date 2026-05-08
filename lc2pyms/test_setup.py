"""
Test script to verify the microservices setup
"""
import requests
import time
import sys

# Service URLs
AUTH_SERVICE = "http://localhost:8000"
SERVICE1 = "http://localhost:8001"
SERVICE2 = "http://localhost:8002"

def test_health_checks():
    """Test health endpoints of all services"""
    print("\n=== Testing Health Checks ===")
    
    services = {
        "Auth Service": f"{AUTH_SERVICE}/health",
        "Service 1": f"{SERVICE1}/health",
        "Service 2": f"{SERVICE2}/health"
    }
    
    for name, url in services.items():
        try:
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                print(f"✓ {name}: Healthy")
            else:
                print(f"✗ {name}: Unhealthy (Status: {response.status_code})")
                return False
        except Exception as e:
            print(f"✗ {name}: Connection failed - {e}")
            return False
    
    return True


def test_authentication_flow():
    """Test complete authentication flow"""
    print("\n=== Testing Authentication Flow ===")
    
    # 1. Register a test user
    print("\n1. Registering test user...")
    register_data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "testpass123"
    }
    
    try:
        response = requests.post(
            f"{AUTH_SERVICE}/api/auth/register",
            json=register_data,
            timeout=5
        )
        
        if response.status_code in [201, 400]:  # 400 if user already exists
            print("✓ User registration endpoint working")
        else:
            print(f"✗ Registration failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Registration request failed: {e}")
        return False
    
    # 2. Login and get token
    print("\n2. Logging in...")
    login_data = {
        "username": "testuser",
        "password": "testpass123"
    }
    
    try:
        response = requests.post(
            f"{AUTH_SERVICE}/api/auth/login",
            json=login_data,
            timeout=5
        )
        
        if response.status_code == 200:
            data = response.json()
            token = data.get('token')
            print(f"✓ Login successful, token received: {token[:20]}...")
        else:
            print(f"✗ Login failed: {response.status_code}")
            print(f"Response: {response.text}")
            return False
    except Exception as e:
        print(f"✗ Login request failed: {e}")
        return False
    
    # 3. Validate token
    print("\n3. Validating token...")
    try:
        response = requests.post(
            f"{AUTH_SERVICE}/api/auth/validate",
            json={"token": token},
            timeout=5
        )
        
        if response.status_code == 200:
            data = response.json()
            if data.get('valid'):
                print(f"✓ Token validated for user: {data.get('username')}")
            else:
                print("✗ Token validation failed")
                return False
        else:
            print(f"✗ Token validation request failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Token validation request failed: {e}")
        return False
    
    return token


def test_protected_endpoints(token):
    """Test protected endpoints in client services"""
    print("\n=== Testing Protected Endpoints ===")
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # Test Service 1 - User Profile
    print("\n1. Testing Service 1 (User Management)...")
    try:
        response = requests.get(
            f"{SERVICE1}/api/users/profile",
            headers=headers,
            timeout=5
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Got user profile: {data.get('username')}")
        else:
            print(f"✗ Failed to get profile: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Service 1 request failed: {e}")
        return False
    
    # Test Service 2 - Analytics Dashboard
    print("\n2. Testing Service 2 (Data Analytics)...")
    try:
        response = requests.get(
            f"{SERVICE2}/api/analytics/dashboard",
            headers=headers,
            timeout=5
        )
        
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Got analytics dashboard for: {data.get('username')}")
            print(f"  Summary: {data.get('summary')}")
        else:
            print(f"✗ Failed to get dashboard: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Service 2 request failed: {e}")
        return False
    
    return True


def test_unauthorized_access():
    """Test that endpoints reject unauthorized requests"""
    print("\n=== Testing Unauthorized Access ===")
    
    endpoints = [
        f"{SERVICE1}/api/users/profile",
        f"{SERVICE2}/api/analytics/dashboard"
    ]
    
    for endpoint in endpoints:
        try:
            response = requests.get(endpoint, timeout=5)
            if response.status_code == 401:
                print(f"✓ {endpoint} correctly rejects unauthorized access")
            else:
                print(f"✗ {endpoint} should return 401, got {response.status_code}")
                return False
        except Exception as e:
            print(f"✗ Request to {endpoint} failed: {e}")
            return False
    
    return True


def main():
    """Run all tests"""
    print("=" * 60)
    print("Microservices Authentication Test Suite")
    print("=" * 60)
    
    print("\nWaiting for services to start...")
    time.sleep(2)
    
    # Run tests
    tests = [
        ("Health Checks", test_health_checks),
        ("Unauthorized Access", test_unauthorized_access),
    ]
    
    results = {}
    for test_name, test_func in tests:
        try:
            result = test_func()
            results[test_name] = result
        except Exception as e:
            print(f"\n✗ {test_name} failed with exception: {e}")
            results[test_name] = False
    
    # Authentication flow test (returns token)
    try:
        token = test_authentication_flow()
        results["Authentication Flow"] = bool(token)
        
        if token:
            # Test protected endpoints with token
            results["Protected Endpoints"] = test_protected_endpoints(token)
    except Exception as e:
        print(f"\n✗ Authentication tests failed with exception: {e}")
        results["Authentication Flow"] = False
        results["Protected Endpoints"] = False
    
    # Print summary
    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)
    
    passed = sum(1 for result in results.values() if result)
    total = len(results)
    
    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{status}: {test_name}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed!")
        return 0
    else:
        print(f"\n⚠️  {total - passed} test(s) failed")
        return 1


if __name__ == "__main__":
    sys.exit(main())