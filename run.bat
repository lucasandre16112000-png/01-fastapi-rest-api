@echo off
REM Script para executar a API FastAPI no Windows
REM Este script ativa o ambiente virtual e inicia o servidor

echo ========================================
echo FastAPI Task Manager - Windows Launcher
echo ========================================
echo.

REM Verificar se o venv existe
if not exist "venv" (
    echo [INFO] Ambiente virtual nao encontrado. Criando...
    python -m venv venv
    echo [OK] Ambiente virtual criado.
    echo.
)

REM Ativar o ambiente virtual
echo [INFO] Ativando ambiente virtual...
call venv\Scripts\activate.bat

REM Verificar se as dependências estão instaladas
echo [INFO] Verificando dependências...
pip show fastapi > nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando dependências...
    pip install -r requirements.txt
    echo [OK] Dependências instaladas.
) else (
    echo [OK] Dependências já estão instaladas.
)

echo.
echo ========================================
echo Iniciando servidor FastAPI...
echo ========================================
echo.
echo API disponível em: http://127.0.0.1:8000
echo Documentação (Swagger): http://127.0.0.1:8000/docs
echo ReDoc: http://127.0.0.1:8000/redoc
echo.
echo Pressione CTRL+C para parar o servidor
echo ========================================
echo.

REM Iniciar o servidor
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

pause
