@echo off
REM Script SUPER SIMPLES para iniciar a API FastAPI
REM Com sistema robusto de detecção de erros e logs

setlocal enabledelayedexpansion

color 0A

REM Mudar para o diretório do script
cd /d "%~dp0"

REM Criar arquivo de log
set "LOG_FILE=%TEMP%\fastapi_iniciar.log"
echo [%date% %time%] Iniciando API... > "%LOG_FILE%"

echo.
echo ========================================
echo FastAPI - Iniciar Automatico
echo ========================================
echo.
echo Diretorio: %cd%
echo.

REM Verificar se estamos no diretório correto
if not exist "requirements.txt" (
    echo [ERRO] Arquivo requirements.txt nao encontrado!
    echo [ERRO] Arquivo requirements.txt nao encontrado! >> "%LOG_FILE%"
    echo Diretorio atual: %cd% >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - Você está executando do ZIP (extraia primeiro)
    echo - Arquivo foi movido ou deletado
    echo - Permissão insuficiente para ler o arquivo
    echo.
    echo Solução:
    echo 1. Extraia o ZIP completamente em um diretório permanente
    echo 2. NAO execute diretamente do ZIP
    echo 3. Exemplo: C:\Projetos\01-fastapi-rest-api
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] requirements.txt encontrado >> "%LOG_FILE%"

REM Verificar se Python está instalado
echo [1/5] Verificando Python...
python --version > "%TEMP%\python_version.txt" 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo [ERRO] Python nao encontrado! >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - Python não está instalado
    echo - Python não está no PATH
    echo - Versão incorreta de Python
    echo.
    echo Solução:
    echo 1. Instale Python 3.9+ em: https://www.python.org/downloads/
    echo 2. Marque a opção "Add Python to PATH" durante a instalação
    echo 3. Reinicie o computador após a instalação
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
set /p PYTHON_VERSION=<"%TEMP%\python_version.txt"
echo [OK] !PYTHON_VERSION! >> "%LOG_FILE%"
echo [OK] !PYTHON_VERSION!
echo.

REM Criar venv se não existir
if not exist "venv" (
    echo [2/5] Criando ambiente virtual...
    python -m venv venv
    if errorlevel 1 (
        echo [ERRO] Falha ao criar venv
        echo [ERRO] Falha ao criar venv >> "%LOG_FILE%"
        echo.
        echo Possíveis causas:
        echo - Sem permissão de escrita no diretório
        echo - Espaço em disco insuficiente
        echo - Caracteres inválidos no caminho
        echo.
        echo Solução:
        echo 1. Execute como Administrador
        echo 2. Verifique se tem espaço em disco
        echo 3. Mova o projeto para um caminho sem caracteres especiais
        echo.
        echo Log: %LOG_FILE%
        pause
        exit /b 1
    )
    echo [OK] venv criado >> "%LOG_FILE%"
) else (
    echo [2/5] Usando venv existente...
    echo [OK] venv já existe >> "%LOG_FILE%"
)
echo.

REM Ativar venv
echo [3/5] Ativando ambiente virtual...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERRO] Falha ao ativar venv
    echo [ERRO] Falha ao ativar venv >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - venv corrompido
    echo - Permissão insuficiente
    echo.
    echo Solução:
    echo 1. Delete a pasta 'venv'
    echo 2. Execute este script novamente
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] venv ativado >> "%LOG_FILE%"
echo.

REM Instalar/atualizar dependências
echo [4/5] Instalando dependências...
pip install -q -r requirements.txt
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependências
    echo [ERRO] Falha ao instalar dependências >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - Sem conexão com a internet
    echo - requirements.txt corrompido
    echo - Permissão insuficiente
    echo.
    echo Solução:
    echo 1. Verifique sua conexão com a internet
    echo 2. Tente novamente
    echo 3. Se persistir, delete 'venv' e tente novamente
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] Dependências instaladas >> "%LOG_FILE%"
echo.

REM Criar .env se não existir
if not exist ".env" (
    echo [5/5] Criando arquivo .env...
    copy .env.example .env > nul
    if errorlevel 1 (
        echo [AVISO] Falha ao criar .env (continuando mesmo assim)
        echo [AVISO] Falha ao criar .env >> "%LOG_FILE%"
    ) else (
        echo [OK] .env criado >> "%LOG_FILE%"
    )
) else (
    echo [5/5] Usando .env existente...
    echo [OK] .env já existe >> "%LOG_FILE%"
)
echo.

echo ========================================
echo API rodando em: http://127.0.0.1:8000
echo Documentacao: http://127.0.0.1:8000/docs
echo ========================================
echo.
echo [INFO] Iniciando servidor Uvicorn >> "%LOG_FILE%"

REM Aguardar 2 segundos e abrir o navegador
timeout /t 2 /nobreak
start http://127.0.0.1:8000/docs

REM Iniciar o servidor
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

echo [INFO] Servidor encerrado >> "%LOG_FILE%"
pause
