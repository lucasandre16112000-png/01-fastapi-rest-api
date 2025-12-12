# /app/main.py
from fastapi import FastAPI

from .database import engine
from . import models
from .routers import tasks, users

models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Professional Task Manager API",
    description="A robust, enterprise-level API for managing users and tasks, built with FastAPI and best practices.",
    version="1.0.0",
)

app.include_router(users.router, prefix="/api/v1", tags=["users"])
app.include_router(tasks.router, prefix="/api/v1", tags=["tasks"])

@app.get("/api/v1/health", tags=["health"])
def health_check():
    """Check the health of the API."""
    return {"status": "healthy"}
