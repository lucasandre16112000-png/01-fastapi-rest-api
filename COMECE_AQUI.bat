@echo off
setlocal enabledelayedexpansion

color 0A

echo.
echo ========================================
echo FastAPI - COMECE AQUI
echo ========================================
echo.

REM Obter o caminho do script (pode estar em ZIP)
set "SCRIPT_PATH=%~dp0"
set "SCRIPT_NAME=%~nx0"

REM Verificar se estamos em uma pasta temporária ou System32
echo Verificando localizacao...
if "!SCRIPT_PATH:System32=!" neq "!SCRIPT_PATH!" (
    echo Detectado: System32 - Procurando arquivo ZIP...
    
    REM Procurar pelo arquivo ZIP no Desktop
    for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"
    if "!DESKTOP!"=="" set "DESKTOP=%USERPROFILE%\Desktop"
    
    REM Procurar ZIP no Desktop
    for /f "delims=" %%F in ('dir /b "!DESKTOP!\*.zip" 2^>nul') do (
        set "ZIP_FILE=!DESKTOP!\%%F"
        goto found_zip
    )
    
    REM Se não encontrou no Desktop, procurar no Downloads
    set "DOWNLOADS=%USERPROFILE%\Downloads"
    for /f "delims=" %%F in ('dir /b "!DOWNLOADS!\*fastapi*.zip" 2^>nul') do (
        set "ZIP_FILE=!DOWNLOADS!\%%F"
        goto found_zip
    )
    
    echo Nao encontrei o ZIP!
    pause
    exit /b 1
)

:found_zip
echo Encontrado: !ZIP_FILE!
echo.

REM Obter Desktop para extração
for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"
if "!DESKTOP!"=="" set "DESKTOP=%USERPROFILE%\Desktop"

REM Caminho de extração
set "EXTRACT_PATH=!DESKTOP!\01-fastapi-rest-api"
set "COUNTER=1"

:check_exists
if exist "!EXTRACT_PATH!" (
    set "EXTRACT_PATH=!DESKTOP!\01-fastapi-rest-api (!COUNTER!)"
    set /a COUNTER=!COUNTER!+1
    goto check_exists
)

echo Extraindo para: !EXTRACT_PATH!
echo.

REM Criar pasta
mkdir "!EXTRACT_PATH!" 2>nul

REM Extrair com PowerShell
echo Extraindo arquivos...
powershell -NoProfile -ExecutionPolicy Bypass -Command "^
Add-Type -AssemblyName System.IO.Compression.FileSystem; ^
[System.IO.Compression.ZipFile]::ExtractToDirectory('!ZIP_FILE!', '!EXTRACT_PATH!'); ^
exit 0;" >nul 2>&1

if errorlevel 1 (
    echo Tentando metodo alternativo...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "^
    $zip = '!ZIP_FILE!'; ^
    $dest = '!EXTRACT_PATH!'; ^
    $shell = New-Object -ComObject Shell.Application; ^
    $zip_file = $shell.NameSpace($zip); ^
    $dest_folder = $shell.NameSpace($dest); ^
    $dest_folder.CopyHere($zip_file.Items(), 16); ^
    exit 0;" >nul 2>&1
)

REM Verificar se foi extraído
if not exist "!EXTRACT_PATH!\COMECE_AQUI.bat" (
    echo ERRO: Falha ao extrair!
    pause
    exit /b 1
)

echo Extracao concluida!
echo.

REM Executar o script no novo local
cd /d "!EXTRACT_PATH!"

REM Procurar pelo arquivo extraído
if exist "01-fastapi-rest-api-main\COMECE_AQUI.bat" (
    cd /d "!EXTRACT_PATH!\01-fastapi-rest-api-main"
)

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
