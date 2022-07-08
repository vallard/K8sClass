from re import I
from pydantic import BaseModel, EmailStr
from typing import Optional, Any


class UserBase(BaseModel):
    email: EmailStr
    password: str


class UserCreate(UserBase):
    pass


class UserSignUp(UserBase):
    pass


class UserGet(BaseModel):
    user_id: int


# what we return to get user info
class UserOut(UserGet):
    email: EmailStr


class UserInDBBase(BaseModel):
    id: Optional[int] = None
    email: str

    class Config:
        orm_mode = True


class UserInDB(UserInDBBase):
    hashed_password: str


class User(UserInDBBase):
    pass
