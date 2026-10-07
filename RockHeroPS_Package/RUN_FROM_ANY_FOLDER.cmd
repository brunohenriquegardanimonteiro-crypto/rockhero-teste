@echo off
setlocal
set "BASE=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%rockhero.ps1" %*
endlocal
