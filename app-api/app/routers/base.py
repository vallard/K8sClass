from re import I
from fastapi import APIRouter, Depends
from app.database import get_db, engine
from sqlalchemy import text
from datetime import datetime, date, timedelta
import redis
import json

router = APIRouter(tags=["base"])

@router.get("/")
async def root():
    return {"status": "ok"}
