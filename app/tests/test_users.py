# /app/tests/test_users.py
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import Base, get_db
from app.models import User

SQLALCHEMY_DATABASE_URL = "sqlite:///./test_users.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

def setup_function():
    Base.metadata.create_all(bind=engine)

def teardown_function():
    Base.metadata.drop_all(bind=engine)

def test_create_user():
    response = client.post(
        "/api/v1/users/",
        json={"email": "test@example.com", "password": "testpassword"},
    )
    assert response.status_code == 201, response.text
    data = response.json()
    assert data["email"] == "test@example.com"
    assert "id" in data

def test_login_for_access_token():
    # First, create a user to login with
    client.post(
        "/api/v1/users/",
        json={"email": "login@example.com", "password": "loginpassword"},
    )
    response = client.post(
        "/api/v1/token",
        data={"username": "login@example.com", "password": "loginpassword"},
    )
    assert response.status_code == 200, response.text
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"

def test_read_users_me():
    # Create user and get token
    client.post(
        "/api/v1/users/",
        json={"email": "me@example.com", "password": "mepassword"},
    )
    login_response = client.post(
        "/api/v1/token",
        data={"username": "me@example.com", "password": "mepassword"},
    )
    token = login_response.json()["access_token"]

    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/api/v1/users/me/", headers=headers)
    assert response.status_code == 200, response.text
    data = response.json()
    assert data["email"] == "me@example.com"
