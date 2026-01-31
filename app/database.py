# /app/database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from pathlib import Path
import os

# Usar pathlib para compatibilidade cross-platform (Windows, Linux, macOS)
db_path = Path(__file__).parent.parent / "test.db"
SQLALCHEMY_DATABASE_URL = f"sqlite:///{db_path}"

# Criar diretório do banco de dados se não existir
db_path.parent.mkdir(parents=True, exist_ok=True)

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
