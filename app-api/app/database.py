from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
import databases
from sqlalchemy.orm import Session, sessionmaker
from fastapi import HTTPException
import os

Base = declarative_base()

db_host = os.environ.get("K8S_DB_HOST", "localhost")
db_user = os.environ.get("K8S_DB_USERNAME", "user")
db_pass = os.environ.get("K8S_DB_PASSWORD", "asdf1234")
db_port = os.environ.get("K8S_DB_PORT", 3306)
db_name = os.environ.get("K8S_DB_DATABASE", "k8sdb")
Database_Url = (
    f"mysql+pymysql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}?charset=utf8mb4"
)
database = databases.Database(Database_Url)

engine = create_engine(Database_Url, pool_pre_ping=True)

# Dependency
def get_db():
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    try:
        yield db
    except:
        db.rollback()
        raise
    finally:
        db.close()
