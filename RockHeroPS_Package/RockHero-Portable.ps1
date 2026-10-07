# Rock Hero Portable Launcher
param(
    [string]$Entry = '',
    [switch]$SelfTest,
    [switch]$NoAudio,
    [switch]$Console
)
$P = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptPath = Join-Path $P 'rockhero.ps1'
& $scriptPath @PSBoundParameters
