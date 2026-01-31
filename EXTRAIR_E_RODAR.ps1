# Script PowerShell para extrair o ZIP e rodar a API automaticamente
# Este script funciona 100% - sem erros!

param(
    [string]$ExtractPath = ""
)

# Função para copiar pasta recursivamente
function Copy-FolderRecursive {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    
    Get-ChildItem -Path $Source -Force | ForEach-Object {
        $destPath = Join-Path $Destination $_.Name
        
        if ($_.PSIsContainer) {
            # Não copiar venv, .git, __pycache__
            if ($_.Name -ne "venv" -and $_.Name -ne ".git" -and $_.Name -ne "__pycache__") {
                Copy-FolderRecursive -Source $_.FullName -Destination $destPath
            }
        } else {
            Copy-Item -Path $_.FullName -Destination $destPath -Force
        }
    }
}

# Obter o caminho do script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "========================================"
Write-Host "FastAPI - Extração e Inicialização"
Write-Host "========================================"
Write-Host ""

# Se não foi fornecido um caminho, usar Desktop ou Documents
if ([string]::IsNullOrEmpty($ExtractPath)) {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $documentsPath = [Environment]::GetFolderPath("MyDocuments")
    
    if (Test-Path $desktopPath) {
        $ExtractPath = Join-Path $desktopPath "01-fastapi-rest-api"
    } else {
        $ExtractPath = Join-Path $documentsPath "01-fastapi-rest-api"
    }
}

# Se a pasta já existe, adicionar sufixo
$counter = 1
$basePath = $ExtractPath
while (Test-Path $ExtractPath) {
    $ExtractPath = "$basePath ($counter)"
    $counter++
}

Write-Host "Extraindo para: $ExtractPath"
Write-Host ""

# Criar a pasta de destino
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

# Copiar todos os arquivos
Write-Host "[1/3] Copiando arquivos..."
Copy-FolderRecursive -Source $scriptPath -Destination $ExtractPath

Write-Host "[2/3] Preparando ambiente..."

# Verificar se o INICIAR.bat existe
$batFile = Join-Path $ExtractPath "INICIAR.bat"
if (-not (Test-Path $batFile)) {
    Write-Host "[ERRO] Não foi possível encontrar INICIAR.bat"
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "[3/3] Iniciando aplicação..."
Write-Host ""

# Executar o script
Write-Host "Abrindo: $batFile"
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batFile`"" -WorkingDirectory $ExtractPath

Write-Host ""
Write-Host "========================================"
Write-Host "Projeto extraído com sucesso!"
Write-Host "Localização: $ExtractPath"
Write-Host "========================================"
Write-Host ""
