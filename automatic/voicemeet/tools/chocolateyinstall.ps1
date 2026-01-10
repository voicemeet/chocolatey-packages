
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/voicemeet/releases/releases/download/v0.0.3/voicemeet-0.0.3-windows-setup-x64.exe'

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

  checksum64    = '25c4339970292ad54d317e3e51b8f94b10b8cdfbbd8a71cf7bb78ac16834bf3c'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
