"""
Database models for authentication service
"""
from sqlalchemy import Column, Integer, String, DateTime, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from passlib.hash import bcrypt
import secrets

Base = declarative_base()


class User(Base):
    """User model for database authentication"""
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    username = Column(String(80), unique=True, nullable=False, index=True)
    email = Column(String(120), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    last_login = Column(DateTime)
    
    def set_password(self, password):
        """Hash and set password"""
        self.password_hash = bcrypt.hash(password)
    
    def check_password(self, password):
        """Verify password against hash"""
        return bcrypt.verify(password, self.password_hash)
    
    def to_dict(self):
        """Convert user to dictionary"""
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_login': self.last_login.isoformat() if self.last_login else None
        }


class Token(Base):
    """Token model for session management"""
    __tablename__ = 'tokens'
    
    id = Column(Integer, primary_key=True)
    token = Column(String(255), unique=True, nullable=False, index=True)
    username = Column(String(80), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    expires_at = Column(DateTime, nullable=False)
    
    @staticmethod
    def generate_token():
        """Generate a secure random token"""
        return secrets.token_urlsafe(32)
    
    def is_expired(self):
        """Check if token is expired"""
        return datetime.utcnow() > self.expires_at
    
    def to_dict(self):
        """Convert token to dictionary"""
        return {
            'token': self.token,
            'username': self.username,
            'created_at': self.created_at.isoformat(),
            'expires_at': self.expires_at.isoformat()
        }


class DatabaseManager:
    """Database connection and session manager"""
    
    def __init__(self, config):
        """Initialize database connection"""
        self.config = config
        self.engine = None
        self.Session = None
        self._init_database()
    
    def _init_database(self):
        """Initialize database engine and create tables"""
        db_config = self.config['database']
        
        if db_config['type'] == 'sqlite':
            db_url = f"sqlite:///{db_config['path']}"
        elif db_config['type'] == 'postgresql':
            db_url = f"postgresql://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['name']}"
        elif db_config['type'] == 'mysql':
            db_url = f"mysql+pymysql://{db_config['user']}:{db_config['password']}@{db_config['host']}:{db_config['port']}/{db_config['name']}"
        else:
            raise ValueError(f"Unsupported database type: {db_config['type']}")
        
        self.engine = create_engine(db_url, echo=False)
        Base.metadata.create_all(self.engine)
        self.Session = sessionmaker(bind=self.engine)
    
    def get_session(self):
        """Get a new database session"""
        return self.Session()
    
    def close(self):
        """Close database connection"""
        if self.engine:
            self.engine.dispose()
