
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/voicemeet/releases/releases/download/v0.0.2/voicemeet-0.0.2-windows-setup-x64.exe'

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

  checksum64    = '7b96becc28bee5e705dd30889b9be35f1918cdc2c8e51e918ee89923a014da9e'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
