# Rock Hero: roda de qualquer pasta (deteta a pasta deste script automaticamente)
$base = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$rh = Join-Path $base 'rockhero.ps1'
& powershell -NoProfile -ExecutionPolicy Bypass -File $rh @args
