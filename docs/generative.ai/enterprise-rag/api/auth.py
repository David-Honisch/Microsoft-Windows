"""
Auth & RBAC Middleware
───────────────────────
JWT-based authentication with role-based access control.

Roles (most → least privileged):
  admin   — full access: all documents, admin endpoints, user management
  editor  — can upload and delete own documents; read all permitted docs
  viewer  — read-only access to permitted document collections

Token structure::

    {
      "sub": "user@acme.com",
      "name": "Alice Smith",
      "role": "editor",
      "groups": ["hr", "all_staff"],
      "exp": <unix timestamp>
    }
"""
from __future__ import annotations

import logging
from datetime import datetime, timedelta, timezone
from typing import Annotated, Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel

from config import settings

logger = logging.getLogger(__name__)

# ── Password hashing ─────────────────────────────────────────────────────────
# sha256_crypt is pure-Python and compatible across all environments.
# Switch to bcrypt in production (requires a compatible bcrypt C extension).
_pwd_context = CryptContext(schemes=["sha256_crypt"], deprecated="auto")

# ── OAuth2 scheme ─────────────────────────────────────────────────────────────
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/token")


# ── Models ────────────────────────────────────────────────────────────────────

class TokenData(BaseModel):
    email: str
    name: str = ""
    role: str = "viewer"
    groups: list[str] = ["all_staff"]


class UserInDB(BaseModel):
    email: str
    name: str
    hashed_password: str
    role: str = "viewer"
    groups: list[str] = ["all_staff"]
    disabled: bool = False


# ── In-memory user store (replace with DB in production) ─────────────────────
# Passwords: admin123 / editor123 / viewer123
# Hashes are computed lazily on first access to avoid import-time failures
# when the bcrypt C extension is not yet fully loaded.
_RAW_USERS: list[tuple] = [
    ("admin@acme.com", "Admin User", "admin123", "admin",
     ["admin", "hr", "legal", "it", "finance", "all_staff"]),
    ("hr@acme.com", "HR Manager", "editor123", "editor",
     ["hr", "all_staff"]),
    ("employee@acme.com", "Jane Employee", "viewer123", "viewer",
     ["all_staff"]),
]
_USERS_DB: dict[str, UserInDB] = {}


def _ensure_users_loaded() -> None:
    """Lazily hash passwords and populate _USERS_DB on first call."""
    if _USERS_DB:
        return
    for email, name, password, role, groups in _RAW_USERS:
        _USERS_DB[email] = UserInDB(
            email=email,
            name=name,
            hashed_password=_pwd_context.hash(password),
            role=role,
            groups=groups,
        )


# ── Token utilities ───────────────────────────────────────────────────────────

def create_access_token(data: dict) -> str:
    payload = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.JWT_EXPIRE_MINUTES)
    payload["exp"] = expire
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.JWT_ALGORITHM)


def verify_password(plain: str, hashed: str) -> bool:
    return _pwd_context.verify(plain, hashed)


def authenticate_user(email: str, password: str) -> Optional[UserInDB]:
    _ensure_users_loaded()
    user = _USERS_DB.get(email)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user


# ── FastAPI Dependencies ──────────────────────────────────────────────────────

async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)]
) -> TokenData:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired authentication token.",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.JWT_ALGORITHM]
        )
        email: str = payload.get("sub", "")
        if not email:
            raise credentials_exception
        return TokenData(
            email=email,
            name=payload.get("name", ""),
            role=payload.get("role", "viewer"),
            groups=payload.get("groups", ["all_staff"]),
        )
    except JWTError:
        raise credentials_exception


def require_role(minimum_role: str):
    """
    Dependency factory that enforces a minimum role level.
    Usage: ``Depends(require_role("editor"))``
    """
    _ROLE_ORDER = {"viewer": 0, "editor": 1, "admin": 2}

    async def _checker(current_user: Annotated[TokenData, Depends(get_current_user)]):
        user_level = _ROLE_ORDER.get(current_user.role, 0)
        required_level = _ROLE_ORDER.get(minimum_role, 0)
        if user_level < required_level:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"This action requires '{minimum_role}' role or higher.",
            )
        return current_user

    return _checker
