# ROCK HERO - EXECUTE DE QUALQUER PASTA
# Pode colar este arquivo onde quiser (ou chamá-lo com caminho completo)
param(
    [string]$Entry = '',
    [switch]$SelfTest,
    [switch]$NoAudio,
    [switch]$Console
)
if ($PSScriptRoot) {
    $ScriptDir = $PSScriptRoot
} else {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}
$Rh = Join-Path $ScriptDir 'rockhero.ps1'
if (-not (Test-Path -LiteralPath $Rh)) {
    # tenta subir um nível se copiado junto com subpasta
    $Rh2 = Join-Path (Join-Path $ScriptDir 'RockHeroPS_Package') 'rockhero.ps1'
    if (Test-Path -LiteralPath $Rh2) { $Rh = $Rh2 }
}
if (-not (Test-Path -LiteralPath $Rh)) {
    throw "rockhero.ps1 não encontrado. Mantenha este script no mesmo diretório de rockhero.ps1."
}
& $Rh @PSBoundParameters
