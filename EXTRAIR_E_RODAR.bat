@echo off
REM Script para extrair o ZIP e rodar a API automaticamente
REM Este é o script mais simples e direto!

setlocal enabledelayedexpansion

echo.
echo ========================================
echo FastAPI - Extracao e Inicializacao
echo ========================================
echo.

REM Obter o caminho do Desktop
for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"

REM Se não conseguir o Desktop, usar a pasta do usuário
if "!DESKTOP!"=="" (
    set "DESKTOP=%USERPROFILE%\Desktop"
)

REM Definir o caminho de extração
set "EXTRACT_PATH=!DESKTOP!\01-fastapi-rest-api"

REM Se já existe, adicionar sufixo
set "COUNTER=1"
:check_exists
if exist "!EXTRACT_PATH!" (
    set "EXTRACT_PATH=!DESKTOP!\01-fastapi-rest-api (!COUNTER!)"
    set /a COUNTER=!COUNTER!+1
    goto check_exists
)

echo Extraindo para: !EXTRACT_PATH!
echo.

REM Criar a pasta
mkdir "!EXTRACT_PATH!" 2>nul

REM Copiar todos os arquivos do diretório atual para o destino
echo [1/3] Copiando arquivos...
xcopy "%~dp0*.*" "!EXTRACT_PATH!\" /E /I /Y >nul 2>&1

REM Excluir venv e .git se existirem
if exist "!EXTRACT_PATH!\venv" rmdir /s /q "!EXTRACT_PATH!\venv" 2>nul
if exist "!EXTRACT_PATH!\.git" rmdir /s /q "!EXTRACT_PATH!\.git" 2>nul

echo [2/3] Preparando ambiente...

REM Verificar se INICIAR.bat existe
if not exist "!EXTRACT_PATH!\INICIAR.bat" (
    echo [ERRO] Nao foi possivel encontrar INICIAR.bat
    pause
    exit /b 1
)

echo [3/3] Iniciando aplicacao...
echo.

REM Executar o script no novo local
cd /d "!EXTRACT_PATH!"
call INICIAR.bat

echo.
echo ========================================
echo Projeto extraido com sucesso!
echo Localizacao: !EXTRACT_PATH!
echo ========================================
echo.
pause
