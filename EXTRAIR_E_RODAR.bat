@echo off
REM Script para extrair o ZIP e rodar a API automaticamente
REM Com sistema robusto de detecção de erros e logs

setlocal enabledelayedexpansion

REM Cores e formatação
color 0A

echo.
echo ========================================
echo FastAPI - Extracao e Inicializacao
echo ========================================
echo.

REM Criar arquivo de log
set "LOG_FILE=%TEMP%\fastapi_extract.log"
echo [%date% %time%] Iniciando extração... > "%LOG_FILE%"

REM Obter o caminho do Desktop
for /f "tokens=3" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop 2^>nul') do set "DESKTOP=%%A"

REM Se não conseguir o Desktop, usar a pasta do usuário
if "!DESKTOP!"=="" (
    set "DESKTOP=%USERPROFILE%\Desktop"
    echo [AVISO] Usando USERPROFILE em vez de Desktop >> "%LOG_FILE%"
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
echo Caminho: !EXTRACT_PATH! >> "%LOG_FILE%"
echo.

REM Criar a pasta
echo [INFO] Criando diretório de destino...
mkdir "!EXTRACT_PATH!" 2>nul
if errorlevel 1 (
    echo [ERRO] Falha ao criar diretório: !EXTRACT_PATH!
    echo [ERRO] Falha ao criar diretório: !EXTRACT_PATH! >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - Sem permissão de escrita no Desktop
    echo - Caminho muito longo
    echo - Caracteres inválidos no caminho
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] Diretório criado >> "%LOG_FILE%"

REM Copiar todos os arquivos do diretório atual para o destino
echo [1/4] Copiando arquivos...
echo [INFO] Iniciando cópia de arquivos >> "%LOG_FILE%"

REM Usar PowerShell para copiar (mais confiável que xcopy)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { ^
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
        Write-Host 'OK'; ^
    } catch { ^
        Write-Host 'ERRO'; ^
        Write-Host $_.Exception.Message; ^
    }" > "%TEMP%\copy_result.txt"

set /p COPY_RESULT=<"%TEMP%\copy_result.txt"

if not "!COPY_RESULT!"=="OK" (
    echo [ERRO] Falha ao copiar arquivos
    echo [ERRO] Falha ao copiar arquivos >> "%LOG_FILE%"
    echo.
    echo Possíveis causas:
    echo - PowerShell não está disponível
    echo - Sem permissão de leitura nos arquivos
    echo - Espaço em disco insuficiente
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] Arquivos copiados >> "%LOG_FILE%"

REM Verificar se os arquivos foram copiados
echo [2/4] Verificando arquivos...
echo [INFO] Verificando arquivos copiados >> "%LOG_FILE%"

if not exist "!EXTRACT_PATH!\INICIAR.bat" (
    echo [ERRO] INICIAR.bat não encontrado após cópia!
    echo [ERRO] INICIAR.bat não encontrado após cópia! >> "%LOG_FILE%"
    echo.
    echo Arquivos no destino:
    dir "!EXTRACT_PATH!" >> "%LOG_FILE%"
    dir "!EXTRACT_PATH!"
    echo.
    echo Possíveis causas:
    echo - Cópia incompleta
    echo - Arquivo não existe na origem
    echo - Permissão insuficiente
    echo.
    echo Log: %LOG_FILE%
    pause
    exit /b 1
)
echo [OK] Arquivos verificados >> "%LOG_FILE%"

if not exist "!EXTRACT_PATH!\requirements.txt" (
    echo [AVISO] requirements.txt não encontrado
    echo [AVISO] requirements.txt não encontrado >> "%LOG_FILE%"
)

REM Limpar venv e .git se existirem
echo [3/4] Limpando arquivos desnecessários...
if exist "!EXTRACT_PATH!\venv" (
    rmdir /s /q "!EXTRACT_PATH!\venv" 2>nul
    echo [OK] venv removido >> "%LOG_FILE%"
)
if exist "!EXTRACT_PATH!\.git" (
    rmdir /s /q "!EXTRACT_PATH!\.git" 2>nul
    echo [OK] .git removido >> "%LOG_FILE%"
)

echo [4/4] Iniciando aplicação...
echo [INFO] Iniciando INICIAR.bat >> "%LOG_FILE%"
echo.

REM Executar o script no novo local
cd /d "!EXTRACT_PATH!"
if errorlevel 1 (
    echo [ERRO] Falha ao mudar para o diretório: !EXTRACT_PATH!
    echo [ERRO] Falha ao mudar para o diretório >> "%LOG_FILE%"
    pause
    exit /b 1
)

call INICIAR.bat
if errorlevel 1 (
    echo [ERRO] Falha ao executar INICIAR.bat >> "%LOG_FILE%"
)

echo.
echo ========================================
echo Projeto extraído com sucesso!
echo Localização: !EXTRACT_PATH!
echo Log: %LOG_FILE%
echo ========================================
echo.
echo [INFO] Extração concluída com sucesso >> "%LOG_FILE%"
pause
