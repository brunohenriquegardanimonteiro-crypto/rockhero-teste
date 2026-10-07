# Rock Hero - execute de qualquer pasta
# Uso: . .\RockHero-Anywhere.ps1  (dot-sourcing) OU  .\RockHero-Anywhere.ps1
param(
  [string]$Entry = '',
  [switch]$SelfTest,
  [switch]$NoAudio,
  [switch]$Console
)
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$Rh = Join-Path $ScriptDir 'rockhero.ps1'
& $Rh @PSBoundParameters
