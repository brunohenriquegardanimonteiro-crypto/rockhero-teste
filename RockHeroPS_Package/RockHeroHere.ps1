# Rodar a partir de QUALQUER pasta. Usa o caminho deste script.
 = 
if (-not ) {  = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path }
& (Join-Path  'rockhero.ps1') @args
