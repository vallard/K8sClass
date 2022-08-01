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
from app.lib.app_logging import setup_logging
from sqlalchemy.orm import Session
import logging
from typing import Any
import requests

router = APIRouter(tags=["auth"])
# PROMETHEUS (part 5)
from prometheus_client import Counter

SUCESSFUL_LOGIN_DETAILS = Counter(
    "successful_login_details", "Successful login details"
)
FAILED_LOGIN_DETAILS = Counter("failed_login_details", "Failed login details")
# END PROMETHEUS (part 5)


# Fluent (part 8)
logger = setup_logging()
# END Fluent (part 8)


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
    new_user = schemas.users.UserCreate(email=user_in.email, password=user_in.password)
    user = crud.user.create(db=db, obj_in=new_user)
    db.commit()
    db.refresh(user)
    sc = SlackClient()
    logger.info(f"New User has signed up: {user.email}")
    sc.post_message(f"New Customer signed up: {user.email}")
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
        # PROMETHEUS (part 5)
        FAILED_LOGIN_DETAILS.inc()
        # END PROMETHEUS (part 5)
        # Fluent (part 8)
        logger.warning(f"Failed login attempt: %s", {form_data.username})
        # END Fluent (part 8)

        raise HTTPException(status_code=400, detail="Incorrect username or password")

    # PROMETHEUS (part 5)
    SUCESSFUL_LOGIN_DETAILS.inc()
    # END PROMETHEUS (part 5)

    # Fluent (part 8)
    logger.info(f"User {user.email} has logged in")
    # END Fluent (part 8)
    return {
        "access_token": create_access_token(sub=user.id),  # 4
        "token_type": "bearer",
    }
