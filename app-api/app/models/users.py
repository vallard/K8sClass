from typing import Optional
from sqlalchemy.orm import relationship
from sqlalchemy import (
    ForeignKey,
    Boolean,
    Column,
    Integer,
    String,
    null,
    text,
    Text,
    DateTime,
)

from app.database import Base


class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(64), nullable=False, unique=True)
    hashed_password = Column(String(256), nullable=False)
    created_at = Column(
        DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP")
    )
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
    )
