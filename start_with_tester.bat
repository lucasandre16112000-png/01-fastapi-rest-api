@echo off
REM Script para iniciar a API e o testador juntos no Windows

echo ========================================
echo FastAPI + API Tester - Windows Launcher
echo ========================================
echo.

REM Verificar se o venv existe
if not exist "venv" (
    echo [INFO] Ambiente virtual nao encontrado. Criando...
    python -m venv venv
    echo [OK] Ambiente virtual criado.
    echo.
)

REM Ativar o ambiente virtual
echo [INFO] Ativando ambiente virtual...
call venv\Scripts\activate.bat

REM Verificar se as dependências estão instaladas
echo [INFO] Verificando dependências...
pip show fastapi > nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando dependências...
    pip install -r requirements.txt
    echo [OK] Dependências instaladas.
) else (
    echo [OK] Dependências já estão instaladas.
)

echo.
echo ========================================
echo Iniciando API e Testador...
echo ========================================
echo.

REM Abrir duas janelas de terminal
REM Uma para a API
start cmd /k "cd /d %cd% && venv\Scripts\activate.bat && echo. && echo ========================================= && echo API FastAPI rodando... && echo ========================================= && echo. && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

REM Aguardar a API iniciar
timeout /t 3 /nobreak

REM Outra para o testador
start cmd /k "cd /d %cd% && venv\Scripts\activate.bat && echo. && echo ========================================= && echo Testador de API rodando... && echo ========================================= && echo. && python serve_tester.py"

REM Aguardar um pouco e abrir o navegador
timeout /t 3 /nobreak

REM Abrir o navegador
echo [INFO] Abrindo navegador...
start http://127.0.0.1:8001/api_tester.html

echo.
echo ========================================
echo ✅ API e Testador iniciados!
echo ========================================
echo.
echo API: http://127.0.0.1:8000
echo Testador: http://127.0.0.1:8001/api_tester.html
echo Docs: http://127.0.0.1:8000/docs
echo.
pause
