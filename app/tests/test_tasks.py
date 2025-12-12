# /app/tests/test_tasks.py
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import Base, get_db

SQLALCHEMY_DATABASE_URL = "sqlite:///./test_tasks.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


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

def get_auth_header():
    client.post("/api/v1/users/", json={"email": "taskuser@example.com", "password": "taskpassword"})
    login_response = client.post("/api/v1/token", data={"username": "taskuser@example.com", "password": "taskpassword"})
    token = login_response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

def test_create_task():
    headers = get_auth_header()
    response = client.post(
        "/api/v1/tasks/",
        headers=headers,
        json={"title": "Test Task", "description": "Test Description", "priority": 2},
    )
    assert response.status_code == 201, response.text
    data = response.json()
    assert data["title"] == "Test Task"
    assert data["description"] == "Test Description"
    assert "id" in data

def test_read_tasks():
    headers = get_auth_header()
    client.post("/api/v1/tasks/", headers=headers, json={"title": "Task 1"})
    client.post("/api/v1/tasks/", headers=headers, json={"title": "Task 2"})

    response = client.get("/api/v1/tasks/", headers=headers)
    assert response.status_code == 200
    assert len(response.json()) >= 2

def test_read_task():
    headers = get_auth_header()
    post_response = client.post("/api/v1/tasks/", headers=headers, json={"title": "Read Me"})
    task_id = post_response.json()["id"]

    response = client.get(f"/api/v1/tasks/{task_id}", headers=headers)
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Read Me"
    assert data["id"] == task_id

def test_update_task():
    headers = get_auth_header()
    post_response = client.post("/api/v1/tasks/", headers=headers, json={"title": "Update Me"})
    task_id = post_response.json()["id"]

    response = client.put(
        f"/api/v1/tasks/{task_id}",
        headers=headers,
        json={"title": "Updated Title", "description": "Updated Description", "priority": 3},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Updated Title"
    assert data["description"] == "Updated Description"

def test_delete_task():
    headers = get_auth_header()
    post_response = client.post("/api/v1/tasks/", headers=headers, json={"title": "Delete Me"})
    task_id = post_response.json()["id"]

    delete_response = client.delete(f"/api/v1/tasks/{task_id}", headers=headers)
    assert delete_response.status_code == 200

    get_response = client.get(f"/api/v1/tasks/{task_id}", headers=headers)
    assert get_response.status_code == 404
