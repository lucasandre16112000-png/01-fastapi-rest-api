@echo off
setlocal enabledelayedexpansion

color 0A

echo.
echo ========================================
echo FastAPI - COMECE AQUI
echo ========================================
echo.

REM Obter Desktop
for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"
if "!DESKTOP!"=="" set "DESKTOP=%USERPROFILE%\Desktop"

echo Procurando arquivo ZIP...

REM Procurar ZIP no Desktop
for /f "delims=" %%F in ('dir /b "!DESKTOP!\*fastapi*.zip" 2^>nul') do (
    set "ZIP_FILE=!DESKTOP!\%%F"
    goto found_zip
)

REM Procurar ZIP no Downloads
set "DOWNLOADS=%USERPROFILE%\Downloads"
for /f "delims=" %%F in ('dir /b "!DOWNLOADS!\*fastapi*.zip" 2^>nul') do (
    set "ZIP_FILE=!DOWNLOADS!\%%F"
    goto found_zip
)

echo Nao encontrei o arquivo ZIP!
pause
exit /b 1

:found_zip
echo Encontrado: !ZIP_FILE!
echo.

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

REM Criar script VBS para extrair ZIP
set "VBS_FILE=%TEMP%\extract_zip.vbs"

(
    echo Set objArgs = WScript.Arguments
    echo InputFile = objArgs^(0^)
    echo OutputFolder = objArgs^(1^)
    echo Set objShell = CreateObject^("Shell.Application"^)
    echo Set objSource = objShell.NameSpace^(InputFile^).Items^(^)
    echo Set objTarget = objShell.NameSpace^(OutputFolder^)
    echo objTarget.CopyHere objSource, 256
    echo WScript.Quit
) > "!VBS_FILE!"

REM Executar VBS para extrair
echo Extraindo arquivos...
cscript.exe //nologo "!VBS_FILE!" "!ZIP_FILE!" "!EXTRACT_PATH!" >nul 2>&1

REM Deletar VBS
del "!VBS_FILE!" 2>nul

REM Aguardar extração
timeout /t 3 /nobreak >nul

REM Verificar se foi extraído
if not exist "!EXTRACT_PATH!\COMECE_AQUI.bat" (
    REM Pode estar em uma subpasta
    if exist "!EXTRACT_PATH!\01-fastapi-rest-api-main\COMECE_AQUI.bat" (
        cd /d "!EXTRACT_PATH!\01-fastapi-rest-api-main"
    ) else (
        echo ERRO: Falha ao extrair!
        pause
        exit /b 1
    )
) else (
    cd /d "!EXTRACT_PATH!"
)

echo Extracao concluida!
echo.

REM Agora executar o fluxo normal
echo Iniciando configuracao...
echo.

REM ========================================
REM VERIFICAR E INSTALAR PYTHON
REM ========================================
echo [1/6] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo AVISO: Python nao encontrado!
    echo.
    echo Baixando Python 3.11...
    echo.
    
    REM Baixar Python
    set "PYTHON_INSTALLER=%TEMP%\python-installer.exe"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "^
    try {^
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
        Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe' -OutFile '!PYTHON_INSTALLER!' -ErrorAction Stop; ^
        Write-Host 'Download concluido'; ^
        exit 0; ^
    } catch {^
        Write-Host 'Erro ao baixar Python'; ^
        exit 1; ^
    }^
    " >nul 2>&1
    
    if exist "!PYTHON_INSTALLER!" (
        echo Instalando Python...
        "!PYTHON_INSTALLER!" /quiet InstallAllUsers=1 PrependPath=1 >nul 2>&1
        timeout /t 5 /nobreak >nul
        del "!PYTHON_INSTALLER!" 2>nul
        
        REM Verificar se Python foi instalado
        python --version >nul 2>&1
        if errorlevel 1 (
            echo ERRO: Falha ao instalar Python!
            echo Instale manualmente em: https://www.python.org/downloads/
            pause
            exit /b 1
        )
    ) else (
        echo ERRO: Falha ao baixar Python!
        echo Instale manualmente em: https://www.python.org/downloads/
        pause
        exit /b 1
    )
)
echo [OK] Python encontrado
echo.

REM ========================================
REM VERIFICAR E INSTALAR GIT
REM ========================================
echo [2/6] Verificando Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo AVISO: Git nao encontrado!
    echo.
    echo Baixando Git...
    echo.
    
    REM Baixar Git
    set "GIT_INSTALLER=%TEMP%\git-installer.exe"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "^
    try {^
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
        Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe' -OutFile '!GIT_INSTALLER!' -ErrorAction Stop; ^
        Write-Host 'Download concluido'; ^
        exit 0; ^
    } catch {^
        Write-Host 'Erro ao baixar Git'; ^
        exit 1; ^
    }^
    " >nul 2>&1
    
    if exist "!GIT_INSTALLER!" (
        echo Instalando Git...
        "!GIT_INSTALLER!" /SILENT /NORESTART >nul 2>&1
        timeout /t 5 /nobreak >nul
        del "!GIT_INSTALLER!" 2>nul
        
        REM Atualizar PATH
        setx PATH "%PATH%;C:\Program Files\Git\cmd" >nul 2>&1
        
        REM Verificar se Git foi instalado
        git --version >nul 2>&1
        if errorlevel 1 (
            echo AVISO: Git pode nao estar disponivel ainda.
            echo Reinicie o computador e tente novamente.
        )
    ) else (
        echo AVISO: Falha ao baixar Git automaticamente.
        echo Instale manualmente em: https://git-scm.com/download/win
    )
)
echo [OK] Git verificado
echo.

REM ========================================
REM CRIAR VENV
REM ========================================
echo [3/6] Criando ambiente virtual...
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

REM ========================================
REM ATIVAR VENV
REM ========================================
echo [4/6] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERRO ao ativar venv!
    pause
    exit /b 1
)
echo [OK] venv ativado
echo.

REM ========================================
REM INSTALAR DEPENDÊNCIAS
REM ========================================
echo [5/6] Instalando dependencias...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo ERRO ao instalar dependencias!
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas
echo.

REM ========================================
REM PREPARAR CONFIGURAÇÕES
REM ========================================
echo [6/6] Preparando configuracoes...
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
