@echo off
REM Script SUPER SIMPLES para iniciar a API FastAPI
REM Basta clicar duas vezes neste arquivo e tudo funciona automaticamente!

setlocal enabledelayedexpansion

REM Mudar para o diretório do script
cd /d "%~dp0"

echo.
echo ========================================
echo FastAPI - Iniciar Automatico
echo ========================================
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
    echo [1/4] Criando ambiente virtual...
    python -m venv venv
    if errorlevel 1 (
        echo [ERRO] Falha ao criar venv
        pause
        exit /b 1
    )
)

REM Ativar venv
call venv\Scripts\activate.bat

REM Instalar/atualizar dependências
echo [2/4] Instalando dependências...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependências
    pause
    exit /b 1
)

REM Criar .env se não existir
if not exist ".env" (
    echo [3/4] Criando arquivo .env...
    copy .env.example .env > nul
)

echo [4/4] Iniciando servidor...
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
