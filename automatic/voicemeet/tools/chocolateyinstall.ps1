
$ErrorActionPreference = 'Stop'
$url64      = 'https://github.com/VoiceMeet/releases/releases/download/v0.0.1%2B2.pre/voicemeet-0.0.1.2.pre-windows-setup-x64.exe'

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

  checksum64    = '79b1ac71d8816907d18109ab6250b1832e4acf73a260c42705fc50c3801fc186'
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
