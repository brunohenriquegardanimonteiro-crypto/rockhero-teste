# Executa Rock Hero a partir deste diretório, independente de onde foi chamado
$dir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$rh = Join-Path $dir 'rockhero.ps1'
if (-not (Test-Path -LiteralPath $rh)) { throw "rockhero.ps1 não encontrado em $dir" }
# Passa todos os argumentos recebidos
& $rh @()
