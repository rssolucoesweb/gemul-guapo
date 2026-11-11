# ============================================================
# GEMUL - Geracao de HASH para Registro de Software
# Algoritmo: SHA-256
# ============================================================

$PastaRaiz = $PSScriptRoot

# Extensoes que fazem parte do codigo-fonte
$Extensoes = @(
    ".asp",
    ".js",
    ".css",
    ".sql",
    ".html",
    ".htm",
    ".xml",
    ".json"
)

Write-Host ""
Write-Host "GEMUL - Geracao de HASH para Registro de Software"
Write-Host "=================================================="
Write-Host "Pasta: $PastaRaiz"
Write-Host ""

# Localiza os arquivos e ordena pelo caminho relativo
$Arquivos = Get-ChildItem -Path $PastaRaiz -Recurse -File |
    Where-Object {
        $Extensoes -contains $_.Extension.ToLower() -and
        $_.Name -ne "gerar_hash_gemul.ps1"
    } |
    Sort-Object {
        $_.FullName.Substring($PastaRaiz.Length).Replace("\", "/").ToLower()
    }

if ($Arquivos.Count -eq 0) {
    Write-Host "Nenhum arquivo de codigo-fonte encontrado."
    exit
}

Write-Host "Arquivos encontrados: $($Arquivos.Count)"
Write-Host ""

# Arquivo temporario contendo caminho + SHA256 de cada arquivo
$Manifesto = Join-Path $env:TEMP "gemul_manifesto_hash.txt"

if (Test-Path $Manifesto) {
    Remove-Item $Manifesto
}

foreach ($Arquivo in $Arquivos) {

    $CaminhoRelativo = $Arquivo.FullName.Substring($PastaRaiz.Length)
    $CaminhoRelativo = $CaminhoRelativo.TrimStart("\").Replace("\", "/").ToLower()

    $HashArquivo = (Get-FileHash `
        -Path $Arquivo.FullName `
        -Algorithm SHA256).Hash.ToLower()

    "$CaminhoRelativo|$HashArquivo" |
        Out-File `
            -FilePath $Manifesto `
            -Append `
            -Encoding utf8
}

# Gera o HASH consolidado
$HashFinal = (Get-FileHash `
    -Path $Manifesto `
    -Algorithm SHA256).Hash.ToUpper()

Write-Host "=================================================="
Write-Host ""
Write-Host "ALGORITMO:"
Write-Host "SHA-256"
Write-Host ""
Write-Host "RESUMO DIGITAL:"
Write-Host $HashFinal
Write-Host ""
Write-Host "Quantidade de arquivos: $($Arquivos.Count)"
Write-Host ""
Write-Host "=================================================="

# Salva o resultado
$Resultado = Join-Path $PastaRaiz "HASH_REGISTRO_GEMUL.txt"

@"
GEMUL - Sistema Integrado de Gestao Educacional

Algoritmo utilizado:
SHA-256

Resumo digital (HASH):
$HashFinal

Quantidade de arquivos considerados:
$($Arquivos.Count)

Data de geracao:
$(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
"@ | Set-Content -Path $Resultado -Encoding UTF8

Remove-Item $Manifesto

Write-Host "Resultado salvo em:"
Write-Host $Resultado
Write-Host ""