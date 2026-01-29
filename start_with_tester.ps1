# Script PowerShell para iniciar a API e o testador juntos no Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FastAPI + API Tester - Windows Launcher" -ForegroundColor Cyan
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
Write-Host "Iniciando API e Testador..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Iniciar a API em background
Write-Host "[INFO] Iniciando API FastAPI..." -ForegroundColor Yellow
$apiProcess = Start-Process -NoNewWindow -PassThru -FilePath "cmd.exe" -ArgumentList "/c cd /d $pwd && venv\Scripts\activate.bat && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"

# Aguardar a API iniciar
Start-Sleep -Seconds 3

# Iniciar o testador em background
Write-Host "[INFO] Iniciando Testador de API..." -ForegroundColor Yellow
$testerProcess = Start-Process -NoNewWindow -PassThru -FilePath "cmd.exe" -ArgumentList "/c cd /d $pwd && venv\Scripts\activate.bat && python serve_tester.py"

# Aguardar um pouco e abrir o navegador
Start-Sleep -Seconds 3

# Abrir o navegador
Write-Host "[INFO] Abrindo navegador..." -ForegroundColor Yellow
Start-Process "http://127.0.0.1:8001/api_tester.html"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ API e Testador iniciados!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "API: http://127.0.0.1:8000" -ForegroundColor Cyan
Write-Host "Testador: http://127.0.0.1:8001/api_tester.html" -ForegroundColor Cyan
Write-Host "Documentação: http://127.0.0.1:8000/docs" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pressione CTRL+C para parar..." -ForegroundColor Yellow
Write-Host ""

# Manter o script rodando
while ($true) {
    Start-Sleep -Seconds 1
}
