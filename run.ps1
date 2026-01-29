# Script PowerShell para executar a API FastAPI no Windows
# Use: powershell -ExecutionPolicy Bypass -File run.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FastAPI Task Manager - Windows Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se o venv existe
if (-not (Test-Path "venv")) {
    Write-Host "[INFO] Ambiente virtual nao encontrado. Criando..." -ForegroundColor Yellow
    python -m venv venv
    Write-Host "[OK] Ambiente virtual criado." -ForegroundColor Green
    Write-Host ""
}

# Ativar o ambiente virtual
Write-Host "[INFO] Ativando ambiente virtual..." -ForegroundColor Yellow
& "venv\Scripts\Activate.ps1"

# Verificar se as dependências estão instaladas
Write-Host "[INFO] Verificando dependências..." -ForegroundColor Yellow
$fastapi_check = pip show fastapi 2>$null
if (-not $fastapi_check) {
    Write-Host "[INFO] Instalando dependências..." -ForegroundColor Yellow
    pip install -r requirements.txt
    Write-Host "[OK] Dependências instaladas." -ForegroundColor Green
} else {
    Write-Host "[OK] Dependências já estão instaladas." -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Iniciando servidor FastAPI..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "API disponível em: http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "Documentação (Swagger): http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "ReDoc: http://127.0.0.1:8000/redoc" -ForegroundColor Green
Write-Host ""
Write-Host "Pressione CTRL+C para parar o servidor" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Iniciar o servidor
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

Read-Host "Pressione Enter para sair"
