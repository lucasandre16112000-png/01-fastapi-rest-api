@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo.
echo ========================================
echo FastAPI - Iniciar
echo ========================================
echo.

REM Verificar requirements.txt
if not exist "requirements.txt" (
    echo ERRO: requirements.txt nao encontrado!
    echo.
    echo Solucao:
    echo 1. Use EXTRAIR_E_RODAR.bat para extrair
    echo 2. Nao execute do ZIP
    echo.
    pause
    exit /b 1
)

REM Verificar Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo.
    echo Instale em: https://www.python.org/downloads/
    echo Marque: "Add Python to PATH"
    echo.
    pause
    exit /b 1
)

echo [1/5] Criando venv...
if not exist "venv" python -m venv venv
if errorlevel 1 (
    echo ERRO ao criar venv!
    pause
    exit /b 1
)

echo [2/5] Ativando venv...
call venv\Scripts\activate.bat

echo [3/5] Instalando dependencias...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo ERRO ao instalar dependencias!
    pause
    exit /b 1
)

echo [4/5] Criando .env...
if not exist ".env" copy .env.example .env >nul

echo [5/5] Iniciando API...
echo.
echo API: http://127.0.0.1:8000
echo Docs: http://127.0.0.1:8000/docs
echo.

timeout /t 2 /nobreak
start http://127.0.0.1:8000/docs

uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

pause
