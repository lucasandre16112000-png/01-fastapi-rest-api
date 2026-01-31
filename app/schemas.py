# /app/schemas.py
from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from datetime import datetime

# ============================================================================
# SCHEMAS - TAREFAS
# ============================================================================

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    priority: int = 1

class TaskCreate(TaskBase):
    pass

class TaskUpdate(TaskBase):
    pass

class Task(TaskBase):
    id: int
    owner_id: int
    completed: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)

# ============================================================================
# SCHEMAS - USUÁRIOS
# ============================================================================

class UserBase(BaseModel):
    email: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool
    tasks: List[Task] = []

    model_config = ConfigDict(from_attributes=True)

# ============================================================================
# SCHEMAS - TOKEN
# ============================================================================

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None
