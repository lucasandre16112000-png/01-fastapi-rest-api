@echo off
REM Script de diagnóstico para identificar problemas

setlocal enabledelayedexpansion

color 0C

echo.
echo ========================================
echo FastAPI - Diagnostico do Sistema
echo ========================================
echo.

set "DIAG_FILE=%TEMP%\fastapi_diagnostico.log"
echo [%date% %time%] Iniciando diagnóstico... > "%DIAG_FILE%"

REM Informações do Sistema
echo [SISTEMA]
echo Computador: %COMPUTERNAME%
echo Usuário: %USERNAME%
echo Diretório Atual: %cd%
echo.
echo [SISTEMA] >> "%DIAG_FILE%"
echo Computador: %COMPUTERNAME% >> "%DIAG_FILE%"
echo Usuário: %USERNAME% >> "%DIAG_FILE%"
echo Diretório Atual: %cd% >> "%DIAG_FILE%"
echo. >> "%DIAG_FILE%"

REM Verificar Python
echo [PYTHON]
python --version 2>&1
if errorlevel 1 (
    echo [ERRO] Python NÃO encontrado
    echo [ERRO] Python NÃO encontrado >> "%DIAG_FILE%"
) else (
    echo [OK] Python encontrado
    echo [OK] Python encontrado >> "%DIAG_FILE%"
    where python >> "%DIAG_FILE%"
)
echo.
echo. >> "%DIAG_FILE%"

REM Verificar pip
echo [PIP]
pip --version 2>&1
if errorlevel 1 (
    echo [ERRO] pip NÃO encontrado
    echo [ERRO] pip NÃO encontrado >> "%DIAG_FILE%"
) else (
    echo [OK] pip encontrado
    echo [OK] pip encontrado >> "%DIAG_FILE%"
)
echo.
echo. >> "%DIAG_FILE%"

REM Verificar arquivos importantes
echo [ARQUIVOS]
if exist "requirements.txt" (
    echo [OK] requirements.txt encontrado
    echo [OK] requirements.txt encontrado >> "%DIAG_FILE%"
) else (
    echo [ERRO] requirements.txt NÃO encontrado
    echo [ERRO] requirements.txt NÃO encontrado >> "%DIAG_FILE%"
)

if exist ".env.example" (
    echo [OK] .env.example encontrado
    echo [OK] .env.example encontrado >> "%DIAG_FILE%"
) else (
    echo [ERRO] .env.example NÃO encontrado
    echo [ERRO] .env.example NÃO encontrado >> "%DIAG_FILE%"
)

if exist "app\main.py" (
    echo [OK] app\main.py encontrado
    echo [OK] app\main.py encontrado >> "%DIAG_FILE%"
) else (
    echo [ERRO] app\main.py NÃO encontrado
    echo [ERRO] app\main.py NÃO encontrado >> "%DIAG_FILE%"
)

if exist "venv" (
    echo [OK] venv encontrado
    echo [OK] venv encontrado >> "%DIAG_FILE%"
) else (
    echo [AVISO] venv NÃO encontrado (será criado automaticamente)
    echo [AVISO] venv NÃO encontrado >> "%DIAG_FILE%"
)
echo.
echo. >> "%DIAG_FILE%"

REM Verificar permissões
echo [PERMISSOES]
if exist "requirements.txt" (
    echo [INFO] Tentando ler requirements.txt...
    type requirements.txt > nul 2>&1
    if errorlevel 1 (
        echo [ERRO] Sem permissão de leitura em requirements.txt
        echo [ERRO] Sem permissão de leitura em requirements.txt >> "%DIAG_FILE%"
    ) else (
        echo [OK] Permissão de leitura OK
        echo [OK] Permissão de leitura OK >> "%DIAG_FILE%"
    )
)

echo [INFO] Tentando criar arquivo de teste...
echo teste > "%TEMP%\test_write.txt" 2>nul
if errorlevel 1 (
    echo [ERRO] Sem permissão de escrita em %TEMP%
    echo [ERRO] Sem permissão de escrita em %TEMP% >> "%DIAG_FILE%"
) else (
    echo [OK] Permissão de escrita OK
    echo [OK] Permissão de escrita OK >> "%DIAG_FILE%"
    del "%TEMP%\test_write.txt" 2>nul
)
echo.
echo. >> "%DIAG_FILE%"

REM Verificar conexão com internet
echo [INTERNET]
ping google.com -n 1 > nul 2>&1
if errorlevel 1 (
    echo [AVISO] Sem conexão com a internet (ou ping bloqueado)
    echo [AVISO] Sem conexão com a internet >> "%DIAG_FILE%"
) else (
    echo [OK] Conexão com internet OK
    echo [OK] Conexão com internet OK >> "%DIAG_FILE%"
)
echo.
echo. >> "%DIAG_FILE%"

REM PowerShell
echo [POWERSHELL]
powershell -NoProfile -Command "Write-Host '[OK] PowerShell disponível'" 2>nul
if errorlevel 1 (
    echo [AVISO] PowerShell não está disponível
    echo [AVISO] PowerShell não está disponível >> "%DIAG_FILE%"
) else (
    echo [OK] PowerShell disponível
    echo [OK] PowerShell disponível >> "%DIAG_FILE%"
)
echo.
echo. >> "%DIAG_FILE%"

REM Resumo
echo ========================================
echo RESUMO DO DIAGNOSTICO
echo ========================================
echo.
echo Se você viu [ERRO] acima, aqui estão as soluções:
echo.
echo [ERRO] Python NÃO encontrado:
echo   - Instale Python 3.9+ em https://www.python.org/downloads/
echo   - Marque "Add Python to PATH" durante a instalação
echo   - Reinicie o computador
echo.
echo [ERRO] requirements.txt NÃO encontrado:
echo   - Use EXTRAIR_E_RODAR.bat para extrair corretamente
echo   - Não execute diretamente do ZIP
echo.
echo [ERRO] Sem permissão:
echo   - Execute como Administrador
echo   - Clique direito no arquivo > Executar como administrador
echo.
echo [AVISO] Sem conexão com internet:
echo   - Verifique sua conexão
echo   - Tente novamente
echo.
echo Log completo: %DIAG_FILE%
echo.
pause
