# Rock Hero - executa de qualquer pasta (resolve caminho absoluto deste script)
$P = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$rh = Join-Path $P 'rockhero.ps1'
if (-not (Test-Path -LiteralPath $rh)) {
    throw "Nao encontrei rockhero.ps1 em: $rh"
}
& $rh @PSBoundParameters
