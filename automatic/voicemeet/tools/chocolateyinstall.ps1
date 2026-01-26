
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/voicemeet/releases/releases/download/v0.0.4/VoiceMeetSetup-0.0.4-x64.exe'

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

  checksum64    = '61d5a714944bb07dc88b45353885c41155d3b8ca29f8969468b6328a383801b7'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
