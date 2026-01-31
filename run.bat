@echo off
REM Script para executar a API FastAPI no Windows
REM Este script ativa o ambiente virtual e inicia o servidor

setlocal enabledelayedexpansion

REM Obter o diretório do script
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo ========================================
echo FastAPI Task Manager - Windows Launcher
echo ========================================
echo.
echo Diretorio: %cd%
echo.

REM Verificar se requirements.txt existe
if not exist "requirements.txt" (
    echo [ERRO] Arquivo requirements.txt nao encontrado!
    echo.
    echo Solucao:
    echo 1. Extraia o ZIP completamente em um diretório permanente
    echo 2. NAO execute diretamente do ZIP
    echo 3. Exemplo: C:\Projetos\01-fastapi-rest-api
    echo.
    pause
    exit /b 1
)

REM Verificar se Python está instalado
python --version > nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado! Por favor, instale Python 3.9+
    echo Visite: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Verificar se o venv existe
if not exist "venv" (
    echo [INFO] Ambiente virtual nao encontrado. Criando...
    python -m venv venv
    if errorlevel 1 (
        echo [ERRO] Falha ao criar ambiente virtual
        pause
        exit /b 1
    )
    echo [OK] Ambiente virtual criado.
    echo.
)

REM Ativar o ambiente virtual
echo [INFO] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERRO] Falha ao ativar ambiente virtual
    pause
    exit /b 1
)

REM Verificar se as dependências estão instaladas
echo [INFO] Verificando dependências...
pip show fastapi > nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando dependências...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERRO] Falha ao instalar dependências
        pause
        exit /b 1
    )
    echo [OK] Dependências instaladas.
) else (
    echo [OK] Dependências já estão instaladas.
)

REM Criar arquivo .env se não existir
if not exist ".env" (
    echo [INFO] Criando arquivo .env...
    copy .env.example .env > nul
    echo [OK] Arquivo .env criado.
) else (
    echo [OK] Arquivo .env já existe
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
echo Abrindo navegador em 3 segundos...
echo.

REM Aguardar 3 segundos antes de abrir o navegador
timeout /t 3 /nobreak

REM Abrir o navegador com a documentação
start http://127.0.0.1:8000/docs

echo.
echo Pressione CTRL+C para parar o servidor
echo ========================================
echo.

REM Iniciar o servidor
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

pause
