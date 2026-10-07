@echo off
setlocal
set "DIR=%~dp0"
rem Executa direto da pasta deste arquivo
powershell -NoProfile -ExecutionPolicy Bypass -File "%DIR%rockhero.ps1" %*
endlocal
