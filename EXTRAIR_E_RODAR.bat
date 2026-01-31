@echo off
setlocal enabledelayedexpansion

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

echo.
echo Extraindo para: !EXTRACT_PATH!
echo.

REM Criar pasta
mkdir "!EXTRACT_PATH!" 2>nul

REM Copiar arquivos com xcopy (simples e confiável)
echo Copiando arquivos...
xcopy "%~dp0*.*" "!EXTRACT_PATH!\" /E /I /Y >nul 2>&1

REM Copiar pasta app especificamente
if exist "%~dp0app" (
    xcopy "%~dp0app" "!EXTRACT_PATH!\app\" /E /I /Y >nul 2>&1
)

REM Limpar venv e .git
if exist "!EXTRACT_PATH!\venv" rmdir /s /q "!EXTRACT_PATH!\venv" 2>nul
if exist "!EXTRACT_PATH!\.git" rmdir /s /q "!EXTRACT_PATH!\.git" 2>nul

REM Verificar se foi copiado
if not exist "!EXTRACT_PATH!\INICIAR.bat" (
    echo.
    echo ERRO: Falha ao copiar arquivos!
    echo.
    echo Tente manualmente:
    echo 1. Clique direito no ZIP
    echo 2. Selecione "Extrair tudo..."
    echo 3. Escolha um local permanente
    echo 4. Abra a pasta extraída
    echo 5. Clique em INICIAR.bat
    echo.
    pause
    exit /b 1
)

REM Executar INICIAR.bat
cd /d "!EXTRACT_PATH!"
call INICIAR.bat
