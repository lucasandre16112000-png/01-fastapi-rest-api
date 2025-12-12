"""
FastAPI REST API com Autenticação JWT
Exemplo profissional de API robusta com autenticação, validação e documentação automática.
"""

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthCredentials
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime, timedelta
import jwt
import hashlib
from typing import Optional
import os

# Configuração
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

app = FastAPI(
    title="Professional REST API",
    description="API robusta com autenticação JWT, validação de dados e documentação automática",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Segurança
security = HTTPBearer()

# ============================================================================
# MODELOS
# ============================================================================

class UserCreate(BaseModel):
    """Modelo para criação de usuário"""
    email: EmailStr
    password: str = Field(..., min_length=8, description="Senha com mínimo 8 caracteres")
    full_name: str = Field(..., min_length=3)

    class Config:
        json_schema_extra = {
            "example": {
                "email": "user@example.com",
                "password": "secure_password123",
                "full_name": "João Silva"
            }
        }


class User(BaseModel):
    """Modelo de usuário (sem senha)"""
    id: int
    email: str
    full_name: str
    created_at: datetime

    class Config:
        json_schema_extra = {
            "example": {
                "id": 1,
                "email": "user@example.com",
                "full_name": "João Silva",
                "created_at": "2025-12-11T10:30:00"
            }
        }


class TokenResponse(BaseModel):
    """Resposta com token JWT"""
    access_token: str
    token_type: str = "bearer"
    expires_in: int


class TaskCreate(BaseModel):
    """Modelo para criação de tarefa"""
    title: str = Field(..., min_length=3, max_length=200)
    description: Optional[str] = Field(None, max_length=1000)
    priority: str = Field(default="medium", pattern="^(low|medium|high)$")

    class Config:
        json_schema_extra = {
            "example": {
                "title": "Implementar autenticação",
                "description": "Adicionar JWT à API",
                "priority": "high"
            }
        }


class Task(TaskCreate):
    """Modelo de tarefa completo"""
    id: int
    user_id: int
    completed: bool = False
    created_at: datetime
    updated_at: datetime

    class Config:
        json_schema_extra = {
            "example": {
                "id": 1,
                "user_id": 1,
                "title": "Implementar autenticação",
                "description": "Adicionar JWT à API",
                "priority": "high",
                "completed": False,
                "created_at": "2025-12-11T10:30:00",
                "updated_at": "2025-12-11T10:30:00"
            }
        }


# ============================================================================
# BANCO DE DADOS EM MEMÓRIA (para exemplo)
# ============================================================================

users_db = {}
tasks_db = {}
user_counter = 0
task_counter = 0


# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

def hash_password(password: str) -> str:
    """Hash de senha com SHA-256"""
    return hashlib.sha256(password.encode()).hexdigest()


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Criar token JWT"""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def verify_token(credentials: HTTPAuthCredentials) -> dict:
    """Verificar e decodificar token JWT"""
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expirado"
        )
    except jwt.InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido"
        )


# ============================================================================
# ENDPOINTS - AUTENTICAÇÃO
# ============================================================================

@app.post("/auth/register", response_model=User, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserCreate):
    """
    Registrar novo usuário
    
    - **email**: Email único do usuário
    - **password**: Senha com mínimo 8 caracteres
    - **full_name**: Nome completo do usuário
    """
    global user_counter
    
    # Verificar se email já existe
    if any(u["email"] == user_data.email for u in users_db.values()):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email já registrado"
        )
    
    user_counter += 1
    user_id = user_counter
    
    users_db[user_id] = {
        "id": user_id,
        "email": user_data.email,
        "password": hash_password(user_data.password),
        "full_name": user_data.full_name,
        "created_at": datetime.utcnow()
    }
    
    return users_db[user_id]


@app.post("/auth/login", response_model=TokenResponse)
async def login(email: str, password: str):
    """
    Fazer login e obter token JWT
    
    - **email**: Email do usuário
    - **password**: Senha do usuário
    """
    # Buscar usuário
    user = None
    for u in users_db.values():
        if u["email"] == email:
            user = u
            break
    
    if not user or user["password"] != hash_password(password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    # Criar token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user["email"]},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "expires_in": ACCESS_TOKEN_EXPIRE_MINUTES * 60
    }


# ============================================================================
# ENDPOINTS - TAREFAS
# ============================================================================

@app.post("/tasks", response_model=Task, status_code=status.HTTP_201_CREATED)
async def create_task(
    task_data: TaskCreate,
    credentials: HTTPAuthCredentials = Depends(security)
):
    """
    Criar nova tarefa (requer autenticação)
    """
    global task_counter
    
    payload = verify_token(credentials)
    
    # Buscar ID do usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    task_counter += 1
    task_id = task_counter
    now = datetime.utcnow()
    
    tasks_db[task_id] = {
        "id": task_id,
        "user_id": user_id,
        "title": task_data.title,
        "description": task_data.description,
        "priority": task_data.priority,
        "completed": False,
        "created_at": now,
        "updated_at": now
    }
    
    return tasks_db[task_id]


@app.get("/tasks", response_model=list[Task])
async def list_tasks(credentials: HTTPAuthCredentials = Depends(security)):
    """
    Listar tarefas do usuário autenticado
    """
    payload = verify_token(credentials)
    
    # Buscar ID do usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    return [t for t in tasks_db.values() if t["user_id"] == user_id]


@app.get("/tasks/{task_id}", response_model=Task)
async def get_task(task_id: int, credentials: HTTPAuthCredentials = Depends(security)):
    """
    Obter detalhes de uma tarefa específica
    """
    payload = verify_token(credentials)
    
    if task_id not in tasks_db:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
    
    task = tasks_db[task_id]
    
    # Verificar se pertence ao usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    if task["user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN)
    
    return task


@app.put("/tasks/{task_id}", response_model=Task)
async def update_task(
    task_id: int,
    task_data: TaskCreate,
    credentials: HTTPAuthCredentials = Depends(security)
):
    """
    Atualizar uma tarefa
    """
    payload = verify_token(credentials)
    
    if task_id not in tasks_db:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
    
    task = tasks_db[task_id]
    
    # Verificar se pertence ao usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    if task["user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN)
    
    task.update({
        "title": task_data.title,
        "description": task_data.description,
        "priority": task_data.priority,
        "updated_at": datetime.utcnow()
    })
    
    return task


@app.delete("/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_task(task_id: int, credentials: HTTPAuthCredentials = Depends(security)):
    """
    Deletar uma tarefa
    """
    payload = verify_token(credentials)
    
    if task_id not in tasks_db:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
    
    task = tasks_db[task_id]
    
    # Verificar se pertence ao usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    if task["user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN)
    
    del tasks_db[task_id]


@app.patch("/tasks/{task_id}/complete")
async def complete_task(task_id: int, credentials: HTTPAuthCredentials = Depends(security)):
    """
    Marcar tarefa como completa
    """
    payload = verify_token(credentials)
    
    if task_id not in tasks_db:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
    
    task = tasks_db[task_id]
    
    # Verificar se pertence ao usuário
    user_id = None
    for u in users_db.values():
        if u["email"] == payload["sub"]:
            user_id = u["id"]
            break
    
    if task["user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN)
    
    task["completed"] = True
    task["updated_at"] = datetime.utcnow()
    
    return task


# ============================================================================
# HEALTH CHECK
# ============================================================================

@app.get("/health")
async def health_check():
    """Verificar saúde da API"""
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat()
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
