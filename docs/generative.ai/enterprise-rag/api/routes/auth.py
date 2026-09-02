"""Auth routes — login + token issuance."""
from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel

from api.auth import authenticate_user, create_access_token, get_current_user, TokenData

router = APIRouter(prefix="/auth", tags=["Authentication"])


class Token(BaseModel):
    access_token: str
    token_type: str
    user_email: str
    user_name: str
    role: str
    groups: list[str]


@router.post("/token", response_model=Token, summary="Obtain a JWT access token")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = create_access_token({
        "sub": user.email,
        "name": user.name,
        "role": user.role,
        "groups": user.groups,
    })
    return Token(
        access_token=token,
        token_type="bearer",
        user_email=user.email,
        user_name=user.name,
        role=user.role,
        groups=user.groups,
    )


@router.get("/me", response_model=TokenData, summary="Get current user info")
async def get_me(current_user: TokenData = Depends(get_current_user)):
    return current_user
