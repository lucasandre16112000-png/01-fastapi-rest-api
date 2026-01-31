# Script PowerShell para iniciar a API FastAPI
# Mais robusto que o .bat, funciona melhor em alguns casos

# Mudar para o diretório do script
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "========================================"
Write-Host "FastAPI - Iniciar Automatico (PowerShell)"
Write-Host "========================================"
Write-Host ""

# Verificar se Python está instalado
try {
    python --version | Out-Null
} catch {
    Write-Host "[ERRO] Python nao encontrado!"
    Write-Host "Por favor, instale Python 3.9+ em: https://www.python.org/downloads/"
    Write-Host ""
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# Criar venv se não existir
if (-not (Test-Path "venv")) {
    Write-Host "[1/4] Criando ambiente virtual..."
    python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERRO] Falha ao criar venv"
        Read-Host "Pressione ENTER para sair"
        exit 1
    }
}

# Ativar venv
Write-Host "[2/4] Ativando ambiente virtual..."
& ".\venv\Scripts\Activate.ps1"

# Instalar/atualizar dependências
Write-Host "[3/4] Instalando dependências..."
pip install -q -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Falha ao instalar dependências"
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# Criar .env se não existir
if (-not (Test-Path ".env")) {
    Write-Host "[4/4] Criando arquivo .env..."
    Copy-Item ".env.example" ".env"
}

Write-Host ""
Write-Host "========================================"
Write-Host "API rodando em: http://127.0.0.1:8000"
Write-Host "Documentacao: http://127.0.0.1:8000/docs"
Write-Host "========================================"
Write-Host ""

# Abrir navegador
Start-Sleep -Seconds 2
Start-Process "http://127.0.0.1:8000/docs"

# Iniciar o servidor
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

Read-Host "Pressione ENTER para sair"
