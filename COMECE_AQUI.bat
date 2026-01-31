@echo off
setlocal enabledelayedexpansion

color 0A

echo.
echo ========================================
echo FastAPI - COMECE AQUI
echo ========================================
echo.

REM Verificar se estamos em um ZIP temporário
set "CURRENT_PATH=%cd%"
if "!CURRENT_PATH:Temp=!" neq "!CURRENT_PATH!" (
    echo ATENCAO: Voce esta executando do ZIP temporario!
    echo.
    echo Vou extrair para um local permanente...
    echo.
    
    REM Obter Desktop
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
    
    REM Copiar com PowerShell
    powershell -NoProfile -ExecutionPolicy Bypass -Command "^
    $source = '%~dp0'; ^
    $dest = '!EXTRACT_PATH!'; ^
    Get-ChildItem -Path $source -Force | ForEach-Object { ^
        if ($_.PSIsContainer) { ^
            if ($_.Name -ne 'venv' -and $_.Name -ne '.git' -and $_.Name -ne '__pycache__') { ^
                Copy-Item -Path $_.FullName -Destination (Join-Path $dest $_.Name) -Recurse -Force -ErrorAction SilentlyContinue; ^
            } ^
        } else { ^
            Copy-Item -Path $_.FullName -Destination (Join-Path $dest $_.Name) -Force -ErrorAction SilentlyContinue; ^
        } ^
    }; ^
    exit 0;" >nul 2>&1
    
    REM Verificar se foi copiado
    if not exist "!EXTRACT_PATH!\COMECE_AQUI.bat" (
        echo ERRO: Falha ao extrair!
        echo.
        echo Solucao:
        echo 1. Clique direito no ZIP
        echo 2. Selecione "Extrair tudo..."
        echo 3. Escolha Desktop ou Documents
        echo 4. Clique em "Extrair"
        echo 5. Abra a pasta extraída
        echo 6. Clique em COMECE_AQUI.bat
        echo.
        pause
        exit /b 1
    )
    
    REM Executar o script no novo local
    cd /d "!EXTRACT_PATH!"
    call COMECE_AQUI.bat
    exit /b 0
)

REM Se chegou aqui, estamos em um local permanente
echo Verificando arquivos necessarios...
echo.

if not exist "requirements.txt" (
    echo ERRO: requirements.txt nao encontrado!
    echo Diretorio: %cd%
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

echo [1/5] Criando ambiente virtual...
if not exist "venv" (
    python -m venv venv
    if errorlevel 1 (
        echo ERRO ao criar venv!
        pause
        exit /b 1
    )
)

echo [2/5] Ativando ambiente virtual...
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
echo ========================================
echo API: http://127.0.0.1:8000
echo Docs: http://127.0.0.1:8000/docs
echo ========================================
echo.

timeout /t 2 /nobreak
start http://127.0.0.1:8000/docs

uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

pause
