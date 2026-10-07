@echo off
setlocal
REM Resolve absolute path of this batch regardless of current directory
set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%rockhero.ps1" %*
endlocal
