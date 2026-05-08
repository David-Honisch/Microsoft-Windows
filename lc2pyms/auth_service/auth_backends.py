"""
Authentication backends for LDAP and Database
"""
import ldap3
from datetime import datetime, timedelta
from models import User, Token, DatabaseManager
import logging

logger = logging.getLogger(__name__)


class AuthBackend:
    """Base authentication backend interface"""
    
    def authenticate(self, username, password):
        """Authenticate user with username and password"""
        raise NotImplementedError
    
    def create_token(self, username):
        """Create authentication token for user"""
        raise NotImplementedError
    
    def validate_token(self, token):
        """Validate authentication token"""
        raise NotImplementedError
    
    def revoke_token(self, token):
        """Revoke authentication token"""
        raise NotImplementedError


class DatabaseAuthBackend(AuthBackend):
    """Database-based authentication backend"""
    
    def __init__(self, config):
        self.config = config
        self.db_manager = DatabaseManager(config)
        self.token_expiry_minutes = config['server']['token_expiry_minutes']
    
    def authenticate(self, username, password):
        """Authenticate user against database"""
        session = self.db_manager.get_session()
        try:
            user = session.query(User).filter_by(username=username).first()
            
            if user and user.check_password(password):
                # Update last login
                user.last_login = datetime.utcnow()
                session.commit()
                logger.info(f"User {username} authenticated successfully")
                return True, user.to_dict()
            
            logger.warning(f"Authentication failed for user {username}")
            return False, None
        except Exception as e:
            logger.error(f"Database authentication error: {e}")
            return False, None
        finally:
            session.close()
    
    def create_token(self, username):
        """Create authentication token"""
        session = self.db_manager.get_session()
        try:
            # Clean up expired tokens for this user
            expired_tokens = session.query(Token).filter(
                Token.username == username,
                Token.expires_at < datetime.utcnow()
            ).all()
            for token in expired_tokens:
                session.delete(token)
            
            # Create new token
            token = Token()
            token.token = Token.generate_token()
            token.username = username
            token.expires_at = datetime.utcnow() + timedelta(minutes=self.token_expiry_minutes)
            
            session.add(token)
            session.commit()
            
            logger.info(f"Token created for user {username}")
            return token.to_dict()
        except Exception as e:
            logger.error(f"Token creation error: {e}")
            session.rollback()
            return None
        finally:
            session.close()
    
    def validate_token(self, token_str):
        """Validate authentication token"""
        session = self.db_manager.get_session()
        try:
            token = session.query(Token).filter_by(token=token_str).first()
            
            if token and not token.is_expired():
                logger.info(f"Token validated for user {token.username}")
                return True, token.username
            
            if token and token.is_expired():
                logger.warning(f"Expired token used by {token.username}")
                session.delete(token)
                session.commit()
            
            return False, None
        except Exception as e:
            logger.error(f"Token validation error: {e}")
            return False, None
        finally:
            session.close()
    
    def revoke_token(self, token_str):
        """Revoke authentication token"""
        session = self.db_manager.get_session()
        try:
            token = session.query(Token).filter_by(token=token_str).first()
            if token:
                session.delete(token)
                session.commit()
                logger.info(f"Token revoked for user {token.username}")
                return True
            return False
        except Exception as e:
            logger.error(f"Token revocation error: {e}")
            session.rollback()
            return False
        finally:
            session.close()
    
    def create_user(self, username, email, password):
        """Create a new user"""
        session = self.db_manager.get_session()
        try:
            # Check if user already exists
            existing_user = session.query(User).filter(
                (User.username == username) | (User.email == email)
            ).first()
            
            if existing_user:
                logger.warning(f"User creation failed: username or email already exists")
                return False, "Username or email already exists"
            
            # Create new user
            user = User()
            user.username = username
            user.email = email
            user.set_password(password)
            
            session.add(user)
            session.commit()
            
            logger.info(f"User {username} created successfully")
            return True, user.to_dict()
        except Exception as e:
            logger.error(f"User creation error: {e}")
            session.rollback()
            return False, str(e)
        finally:
            session.close()


class LDAPAuthBackend(AuthBackend):
    """LDAP-based authentication backend"""
    
    def __init__(self, config):
        self.config = config
        self.ldap_config = config['ldap']
        self.token_expiry_minutes = config['server']['token_expiry_minutes']
        # Use in-memory token storage for LDAP (in production, use Redis or similar)
        self.tokens = {}
    
    def authenticate(self, username, password):
        """Authenticate user against LDAP"""
        try:
            # Create LDAP server connection
            server = ldap3.Server(self.ldap_config['server'], get_info=ldap3.ALL)
            
            # Format user DN
            user_dn = self.ldap_config['user_dn_template'].format(username=username)
            
            # Try to bind with user credentials
            conn = ldap3.Connection(server, user=user_dn, password=password, auto_bind=True)
            
            if conn.bind():
                # Search for user attributes
                search_filter = self.ldap_config['search_filter'].format(username=username)
                conn.search(
                    search_base=self.ldap_config['base_dn'],
                    search_filter=search_filter,
                    attributes=self.ldap_config['attributes']
                )
                
                if conn.entries:
                    user_info = {
                        'username': username,
                        'attributes': {}
                    }
                    
                    # Extract user attributes
                    entry = conn.entries[0]
                    for attr in self.ldap_config['attributes']:
                        if hasattr(entry, attr):
                            user_info['attributes'][attr] = str(getattr(entry, attr))
                    
                    conn.unbind()
                    logger.info(f"LDAP authentication successful for user {username}")
                    return True, user_info
                
                conn.unbind()
            
            logger.warning(f"LDAP authentication failed for user {username}")
            return False, None
        except ldap3.core.exceptions.LDAPBindError:
            logger.warning(f"LDAP bind failed for user {username}")
            return False, None
        except Exception as e:
            logger.error(f"LDAP authentication error: {e}")
            return False, None
    
    def create_token(self, username):
        """Create authentication token"""
        try:
            token_str = Token.generate_token()
            expires_at = datetime.utcnow() + timedelta(minutes=self.token_expiry_minutes)
            
            self.tokens[token_str] = {
                'username': username,
                'created_at': datetime.utcnow(),
                'expires_at': expires_at
            }
            
            # Clean up expired tokens
            self._cleanup_expired_tokens()
            
            logger.info(f"Token created for LDAP user {username}")
            return {
                'token': token_str,
                'username': username,
                'created_at': datetime.utcnow().isoformat(),
                'expires_at': expires_at.isoformat()
            }
        except Exception as e:
            logger.error(f"Token creation error: {e}")
            return None
    
    def validate_token(self, token_str):
        """Validate authentication token"""
        try:
            if token_str in self.tokens:
                token_data = self.tokens[token_str]
                
                if datetime.utcnow() < token_data['expires_at']:
                    logger.info(f"Token validated for LDAP user {token_data['username']}")
                    return True, token_data['username']
                else:
                    # Token expired, remove it
                    del self.tokens[token_str]
                    logger.warning(f"Expired token used")
            
            return False, None
        except Exception as e:
            logger.error(f"Token validation error: {e}")
            return False, None
    
    def revoke_token(self, token_str):
        """Revoke authentication token"""
        try:
            if token_str in self.tokens:
                username = self.tokens[token_str]['username']
                del self.tokens[token_str]
                logger.info(f"Token revoked for LDAP user {username}")
                return True
            return False
        except Exception as e:
            logger.error(f"Token revocation error: {e}")
            return False
    
    def _cleanup_expired_tokens(self):
        """Remove expired tokens from memory"""
        current_time = datetime.utcnow()
        expired_tokens = [
            token for token, data in self.tokens.items()
            if current_time >= data['expires_at']
        ]
        for token in expired_tokens:
            del self.tokens[token]


def get_auth_backend(config):
    """Factory function to get appropriate auth backend"""
    backend_type = config['auth_backend']
    
    if backend_type == 'database':
        return DatabaseAuthBackend(config)
    elif backend_type == 'ldap':
        return LDAPAuthBackend(config)
    else:
        raise ValueError(f"Unsupported auth backend: {backend_type}")
