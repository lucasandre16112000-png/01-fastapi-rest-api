@echo off
setlocal enabledelayedexpansion

color 0A

echo.
echo ========================================
echo FastAPI - CLONE E RODA
echo ========================================
echo.

REM Obter Desktop
for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"
if "!DESKTOP!"=="" set "DESKTOP=%USERPROFILE%\Desktop"

REM Caminho do projeto
set "PROJECT_PATH=!DESKTOP!\01-fastapi-rest-api"
set "COUNTER=1"

:check_exists
if exist "!PROJECT_PATH!" (
    set "PROJECT_PATH=!DESKTOP!\01-fastapi-rest-api (!COUNTER!)"
    set /a COUNTER=!COUNTER!+1
    goto check_exists
)

echo Clonando do GitHub...
echo Destino: !PROJECT_PATH!
echo.

REM Clonar do GitHub
git clone https://github.com/lucasandre16112000-png/01-fastapi-rest-api.git "!PROJECT_PATH!"

if errorlevel 1 (
    echo ERRO ao clonar do GitHub!
    echo Certifique-se de que tem Git instalado.
    echo Baixe em: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo Clone concluido!
echo.

REM Mudar para o diretório
cd /d "!PROJECT_PATH!"

REM Agora executar o fluxo normal
echo Iniciando configuracao...
echo.

REM Verificar Python
echo [1/5] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo Instale em: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo [OK] Python encontrado
echo.

REM Criar venv
echo [2/5] Criando ambiente virtual...
if not exist "venv" (
    python -m venv venv
    if errorlevel 1 (
        echo ERRO ao criar venv!
        pause
        exit /b 1
    )
)
echo [OK] venv criado
echo.

REM Ativar venv
echo [3/5] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERRO ao ativar venv!
    pause
    exit /b 1
)
echo [OK] venv ativado
echo.

REM Instalar dependências
echo [4/5] Instalando dependencias...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo ERRO ao instalar dependencias!
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas
echo.

REM Criar .env
echo [5/5] Preparando configuracoes...
if not exist ".env" (
    copy .env.example .env >nul
)
echo [OK] Pronto!
echo.

echo ========================================
echo Iniciando API FastAPI...
echo ========================================
echo.
echo API: http://127.0.0.1:8000
echo Docs: http://127.0.0.1:8000/docs
echo.
echo Abrindo navegador em 3 segundos...
echo.

timeout /t 3 /nobreak

start http://127.0.0.1:8000/docs

echo.
echo Pressione CTRL+C para parar a API
echo.

uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

pause
