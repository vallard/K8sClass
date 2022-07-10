from re import I
from fastapi import APIRouter, Depends
import json

router = APIRouter(tags=["base"])

@router.get("/")
async def root():
    return {"status": "ok"}
