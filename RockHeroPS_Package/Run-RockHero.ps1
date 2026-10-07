# Executa Rock Hero independente da pasta atual
param([string]$Entry = '', [switch]$SelfTest, [switch]$NoAudio, [switch]$Console)
$P = Split-Path -Parent $MyInvocation.MyCommand.Path
$rh = Join-Path $P 'rockhero.ps1'
if (-not (Test-Path $rh)) { throw "rockhero.ps1 nao encontrado em $P" }
& $rh @PSBoundParameters