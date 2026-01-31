@echo off
REM Script SUPER SIMPLES para iniciar a API FastAPI
REM Funciona mesmo em diretórios temporários e ZIP extraído!

setlocal enabledelayedexpansion

REM Mudar para o diretório do script
cd /d "%~dp0"

REM Verificar se estamos no diretório correto
if not exist "requirements.txt" (
    echo.
    echo [ERRO] Arquivo requirements.txt nao encontrado!
    echo Diretorio atual: %cd%
    echo.
    echo Solucao:
    echo 1. Extraia o ZIP completamente em um diretório permanente
    echo 2. NAO execute diretamente do ZIP
    echo 3. Exemplo: C:\Projetos\01-fastapi-rest-api
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo FastAPI - Iniciar Automatico
echo ========================================
echo.
echo Diretorio: %cd%
echo.

REM Verificar se Python está instalado
python --version > nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale Python 3.9+ em: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

REM Criar venv se não existir
if not exist "venv" (
    echo [1/5] Criando ambiente virtual...
    python -m venv venv
    if errorlevel 1 (
        echo [ERRO] Falha ao criar venv
        pause
        exit /b 1
    )
)

REM Ativar venv
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERRO] Falha ao ativar venv
    pause
    exit /b 1
)

REM Instalar/atualizar dependências
echo [2/5] Instalando dependências...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependências
    pause
    exit /b 1
)

REM Criar .env se não existir
if not exist ".env" (
    echo [3/5] Criando arquivo .env...
    copy .env.example .env > nul
    if errorlevel 1 (
        echo [ERRO] Falha ao criar .env
        pause
        exit /b 1
    )
)

echo [4/5] Preparando servidor...
echo [5/5] Iniciando...
echo.
echo ========================================
echo API rodando em: http://127.0.0.1:8000
echo Documentacao: http://127.0.0.1:8000/docs
echo ========================================
echo.

REM Aguardar 2 segundos e abrir o navegador
timeout /t 2 /nobreak
start http://127.0.0.1:8000/docs

REM Iniciar o servidor
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

pause
