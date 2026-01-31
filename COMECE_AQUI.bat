@echo off
setlocal enabledelayedexpansion

color 0A

echo.
echo ========================================
echo FastAPI - COMECE AQUI
echo ========================================
echo.

REM FORÇA mudar para o diretório do script
cd /d "%~dp0"

echo Diretorio: %cd%
echo.

REM Verificar se estamos em System32 ou Temp
set "CURRENT_PATH=%cd%"

if "!CURRENT_PATH:System32=!" neq "!CURRENT_PATH!" (
    echo ERRO: Voce esta executando do System32!
    echo.
    echo Isso significa que voce clicou no arquivo DENTRO DO ZIP.
    echo.
    echo ========================================
    echo SOLUCAO:
    echo ========================================
    echo.
    echo 1. Clique com botao DIREITO no arquivo ZIP
    echo 2. Selecione "Extrair tudo..."
    echo 3. Escolha um local permanente:
    echo    - Desktop
    echo    - Documents
    echo    - C:\Projetos\
    echo 4. Clique em "Extrair"
    echo 5. Aguarde completar
    echo 6. Abra a pasta extraida
    echo 7. Clique DUAS VEZES em COMECE_AQUI.bat
    echo.
    echo ========================================
    echo.
    pause
    exit /b 1
)

if "!CURRENT_PATH:Temp=!" neq "!CURRENT_PATH!" (
    echo ERRO: Voce esta executando de uma pasta TEMPORARIA!
    echo.
    echo Isso significa que voce clicou no arquivo DENTRO DO ZIP.
    echo.
    echo ========================================
    echo SOLUCAO:
    echo ========================================
    echo.
    echo 1. Clique com botao DIREITO no arquivo ZIP
    echo 2. Selecione "Extrair tudo..."
    echo 3. Escolha um local permanente:
    echo    - Desktop
    echo    - Documents
    echo    - C:\Projetos\
    echo 4. Clique em "Extrair"
    echo 5. Aguarde completar
    echo 6. Abra a pasta extraida
    echo 7. Clique DUAS VEZES em COMECE_AQUI.bat
    echo.
    echo ========================================
    echo.
    pause
    exit /b 1
)

REM Verificar arquivos
echo Verificando arquivos necessarios...
echo.

if not exist "requirements.txt" (
    echo ERRO: requirements.txt nao encontrado!
    echo Diretorio: %cd%
    echo.
    echo Certifique-se de que extraiu TODOS os arquivos do ZIP.
    echo.
    pause
    exit /b 1
)

if not exist "app\main.py" (
    echo ERRO: app\main.py nao encontrado!
    echo.
    pause
    exit /b 1
)

if not exist ".env.example" (
    echo ERRO: .env.example nao encontrado!
    echo.
    pause
    exit /b 1
)

echo [OK] Todos os arquivos encontrados!
echo.

REM Verificar Python
echo [1/5] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo.
    echo Instale Python 3.9+ em:
    echo https://www.python.org/downloads/
    echo.
    echo IMPORTANTE: Marque "Add Python to PATH"
    echo.
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
    echo.
    echo Verifique sua conexao com a internet e tente novamente.
    echo.
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
