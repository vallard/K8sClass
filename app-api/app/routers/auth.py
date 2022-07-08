import os
import json
from re import I
from webbrowser import get
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from app.database import get_db
from app.models.users import User
from app import schemas
from app import crud
from app.core.security import get_password_hash
from app.core.auth import (
    authenticate,
    create_access_token,
)
from app.lib.slack import SlackClient
from sqlalchemy.orm import Session
import logging
from typing import Any
import requests

router = APIRouter(tags=["auth"])

@router.post("/auth/signup", response_model=schemas.users.User, status_code=201)  # 1
def create_user_signup(
    *,
    db: Session = Depends(get_db),
    user_in: schemas.users.UserSignUp,
):
    """
    Create new user without the need to be logged in.
    """
    user = db.query(User).filter(User.email == user_in.email).first()  # 4
    if user:
        raise HTTPException(  # 5
            status_code=400,
            detail="The user with this email already exists in the system",
        )
    new_user = schemas.users.UserCreate(
        email=user_in.email, password=user_in.password
    )
    user = crud.user.create(db=db, obj_in=new_user)
    db.commit()
    db.refresh(user)
    #sc = SlackClient()
    #sc.post_message(f"New Customer signed up: {user.email}")
    return user


@router.post("/auth/login")
def login(
    db: Session = Depends(get_db), form_data: OAuth2PasswordRequestForm = Depends()  # 1
) -> Any:
    """
    Get the JWT for a user with data from OAuth2 request form body.
    """
    print("form data: ", form_data)
    user = authenticate(
        email=form_data.username,
        password=form_data.password,
        db=db,
    )
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect username or password")

    return {
        "access_token": create_access_token(sub=user.id),  # 4
        "token_type": "bearer",
    }
