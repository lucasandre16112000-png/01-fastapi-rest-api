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

REM Usar PowerShell para copiar (mais confiável que xcopy)
echo Copiando arquivos...
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
if not exist "!EXTRACT_PATH!\INICIAR.bat" (
    echo.
    echo ERRO: Falha ao copiar arquivos!
    echo.
    echo Solucao:
    echo 1. Extraia o ZIP manualmente:
    echo    - Clique direito no ZIP
    echo    - Selecione "Extrair tudo..."
    echo    - Escolha um local permanente (Desktop, Documents, etc)
    echo    - Aguarde completar
    echo.
    echo 2. Abra a pasta extraída
    echo.
    echo 3. Clique DUAS VEZES em INICIAR.bat
    echo.
    pause
    exit /b 1
)

REM Limpar venv e .git
if exist "!EXTRACT_PATH!\venv" rmdir /s /q "!EXTRACT_PATH!\venv" 2>nul
if exist "!EXTRACT_PATH!\.git" rmdir /s /q "!EXTRACT_PATH!\.git" 2>nul

REM Executar INICIAR.bat
cd /d "!EXTRACT_PATH!"
call INICIAR.bat
