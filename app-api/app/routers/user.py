import os
import json
from fastapi import APIRouter, Depends, HTTPException, status
from app.database import get_db
from app.models.users import User
from app.schemas.users import UserCreate, UserOut

# from app.lib.slack import SlackClient
import app.crud
from sqlalchemy.orm import Session
import logging
from app.core.auth import oauth2_scheme
from app.core import deps

logging.basicConfig(level=logging.DEBUG)

router = APIRouter(prefix="/user", tags=["user"])


@router.get("", response_model=UserOut)
def get_user(current_user: User = Depends(deps.get_current_user)):
    user = current_user
    return {"user_id": user.id, "email": user.email}
