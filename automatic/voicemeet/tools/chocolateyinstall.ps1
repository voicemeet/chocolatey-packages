
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/voicemeet/releases/releases/download/v0.0.5/VoiceMeetSetup-0.0.5-x64.exe'

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

  checksum64    = 'c9e5b5d29a4bf84958467ae18e36fb0676fdc81405b597912b43ab22e74f4207'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
