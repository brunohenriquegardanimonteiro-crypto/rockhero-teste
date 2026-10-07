$ErrorActionPreference = 'Stop'
$base = 'C:\Users\bruno\AppData\Local\Temp\opencode'
$log  = Join-Path $base 'drive.log'
$plan = Join-Path $base 'plan.txt'
$drive = Join-Path $base 'console_drive.ps1'
$keys  = Join-Path $base 'keys.ps1'

Remove-Item -LiteralPath $log, ($log + '.txt') -Force -ErrorAction SilentlyContinue

$p = Start-Process powershell -ArgumentList @(
    '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $drive, '-Log', $log
) -PassThru
Write-Host ('child pid=' + $p.Id)

function Send {
    param([string[]]$KeyList, [int]$Gap = 700)
    Set-Content -LiteralPath $plan -Value $KeyList -Encoding ASCII
    $cmd = '-NoProfile -ExecutionPolicy Bypass -File "' + $keys + '" -TargetPid ' + $p.Id +
           ' -PlanFile "' + $plan + '" -GapMs ' + $Gap + ' -Log "' + $log + '"'
    $errFile = Join-Path $base 'inject.err'
    Remove-Item -LiteralPath $errFile -Force -ErrorAction SilentlyContinue
    $k = Start-Process powershell -ArgumentList $cmd -Wait -PassThru -RedirectStandardError $errFile
    if ($k.ExitCode -ne 0) {
        Write-Host ('  injector failed exit=' + $k.ExitCode + ': ' + ((Get-Content -LiteralPath $errFile -Raw) -replace "`r?`n", ' | '))
    }
    Write-Host ('  inject [' + ($KeyList -join ' ') + '] childAlive=' + (-not $p.HasExited))
}

Start-Sleep -Seconds 10
Send @('ENTER')
Start-Sleep -Seconds 1
Send @('ENTER')
Start-Sleep -Seconds 1
Send @('ENTER')
Start-Sleep -Seconds 5
Send @('D1')
Send @('D2')
Start-Sleep -Seconds 3
Send @('ESC')
Send @('ENTER')
Start-Sleep -Seconds 4
Send @('ESC')
Send @('ESC')
Start-Sleep -Seconds 4
Send @('ESC') @('ESC') @('ESC') @('ESC') -Gap 800
Start-Sleep -Seconds 3

$exited = $p.WaitForExit(40000)
Write-Host ('waitForExit=' + $exited + ' exitCode=' + $(if ($p.HasExited) { $p.ExitCode } else { 'running' }))
if (-not $p.HasExited) { $p.Kill(); Write-Host 'killed' }

Write-Host '--------- DRIVE LOG ---------'
Get-Content -LiteralPath $log
Write-Host '--------- TRANSCRIPT TAIL ---------'
if (Test-Path -LiteralPath ($log + '.txt')) { Get-Content -LiteralPath ($log + '.txt') | Select-Object -Last 30 }