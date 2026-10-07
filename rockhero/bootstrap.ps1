# bootstrap.ps1 - RockHero one-liner bootstrap (idempotent)
[CmdletBinding()]
param(
    [string] = 'main',
    [string]  = 'eajdias', # adjust if needed
    [string]C:\Users\bruno\AppData\Local\Temp\rh-repo   = 'rockhero',
    [string]  = '',
    [switch],
    [switch],
    [switch]
)

Continue = 'Stop'
 = Join-Path C:\Users\bruno\AppData\Local 'RockHero'
 = Join-Path  '.state'
 = Join-Path  C:\Users\bruno\AppData\Local\Temp\rh-repo
 = Join-Path  "C:\Users\bruno\AppData\Local\Temp\rh-repo.zip"

New-Item -ItemType Directory -Force -Path ,  | Out-Null

 = "https://github.com//C:\Users\bruno\AppData\Local\Temp\rh-repo/archive/refs/heads/.zip"
 = Join-Path  'rockhero.ps1'

function Get-FileHashString {
    param([string])
    if (-not (Test-Path -LiteralPath )) { return  }
     = Get-FileHash -LiteralPath  -Algorithm SHA256
    return .Hash
}

if (-not (Test-Path -LiteralPath )) {
    try { Invoke-WebRequest -Uri  -OutFile  -UseBasicParsing -ErrorAction Stop } catch {
        # fallback
         = New-Object Net.WebClient
        .DownloadFile(, )
    }
    Expand-Archive -LiteralPath  -DestinationPath  -Force
     = Join-Path  ("C:\Users\bruno\AppData\Local\Temp\rh-repo-")
    if (Test-Path -LiteralPath ) {
        if (Test-Path -LiteralPath ) { Remove-Item -LiteralPath  -Recurse -Force }
        Move-Item -LiteralPath  -Destination 
    }
    Remove-Item  -Force -ErrorAction SilentlyContinue
} else {
    # idempotent check basic: keep existing
}

if (-not (Test-Path -LiteralPath )) {
    throw "rockhero.ps1 não encontrado em "
}

 = @()
if () {  += '-Entry';  +=  }
if () {  += '-SelfTest' }
if ()  {  += '-NoAudio' }
if ()  {  += '-Console' }
&  @Args
if ( -ne 0) { exit  }
