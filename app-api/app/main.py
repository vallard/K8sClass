#!/usr/bin/env python3

import base64
import os, sys
import hashlib
import urllib
import requests
import re
import pprint

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from app.routers import base, user, auth
from app.database import database

app = FastAPI()
app.header = {}


origins = [
    "http://localhost",
    "http://localhost:3000",
    "https://pdxtotheworld.com",
    "https://pdx.totheworld.app",
    "https://www.pdx.totheworld.app",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(base.router)
app.include_router(user.router)
app.include_router(auth.router)


@app.on_event("startup")
async def startup():
    await database.connect()


@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()
