@echo off
REM Script de configuração inicial para Windows
REM Este script cria o venv e instala as dependências

setlocal enabledelayedexpansion

REM Obter o diretório do script
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo ========================================
echo FastAPI Task Manager - Setup Windows
echo ========================================
echo.
echo Diretorio: %cd%
echo.

REM Verificar se Python está instalado
python --version > nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado! Por favor, instale Python 3.9+
    echo Visite: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Python encontrado
python --version
echo.

REM Criar ambiente virtual
echo [INFO] Criando ambiente virtual...
python -m venv venv
if errorlevel 1 (
    echo [ERRO] Falha ao criar ambiente virtual
    echo Verifique se tem permissoes de escrita neste diretorio
    pause
    exit /b 1
)
echo [OK] Ambiente virtual criado
echo.

REM Ativar ambiente virtual
echo [INFO] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERRO] Falha ao ativar ambiente virtual
    pause
    exit /b 1
)
echo [OK] Ambiente virtual ativado
echo.

REM Atualizar pip
echo [INFO] Atualizando pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo [ERRO] Falha ao atualizar pip
    pause
    exit /b 1
)
echo [OK] pip atualizado
echo.

REM Instalar dependências
echo [INFO] Instalando dependências...
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependências
    pause
    exit /b 1
)
echo [OK] Dependências instaladas
echo.

REM Criar arquivo .env se não existir
if not exist ".env" (
    echo [INFO] Criando arquivo .env...
    copy .env.example .env > nul
    echo [OK] Arquivo .env criado. Por favor, atualize os valores conforme necessário.
) else (
    echo [OK] Arquivo .env já existe
)
echo.

echo ========================================
echo Setup concluido com sucesso!
echo ========================================
echo.
echo Proximos passos:
echo 1. Atualize o arquivo .env com suas configuracoes (se necessario)
echo 2. Execute run.bat para iniciar a API
echo.
pause
