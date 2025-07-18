
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/VoiceMeet/voicemeet/releases/download/v0.0.1%2B1.pre/voicemeet-0.0.1.1.pre-windows-x64.exe'

$arch = Get-OSArchitectureWidth -Compare 64

if (-not $arch) {
  Write-Error "This package does not support x86 architecture. Installation is not allowed."
  exit 1
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url64bit      = $url64

  softwareName  = 'voicemeet*'

  checksum64    = 'd5b7d0d8187e1a117abe3666d3f59981cec247eb465220675ca6f076b9059d83'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
