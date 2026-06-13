
$ErrorActionPreference = 'Stop'
$url64         = 'https://github.com/voicemeet/app/releases/download/v0.0.7.8/voicemeet-0.0.7.8-windows-setup-x64.exe'
$urlArm64      = 'https://github.com/voicemeet/app/releases/download/v0.0.7.8/voicemeet-0.0.7.8-windows-setup-arm64.exe'
$checksum64    = 'f5a3134168e939432d01d9214c7609748ae3ffe2eacfc57131074fb1e81f6553'
$checksumArm64 = '89630ccbbff7c61323b27a31e94a0605b67e14dd8d4877142f0964a7f733b637'

# OS/CPU
$osIs64  = [Environment]::Is64BitOperatingSystem
$onArm64 = ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64')

if (($env:ChocolateyForceX86 -eq 'true')) {
    throw "No 32-bit installer is published for version $version (force-x86 set)."
} elseif ($onArm64) {
    $selectedUrl64      = $urlArm64
    $selectedChecksum64 = $checksumArm64
} elseif ($osIs64) {
    $selectedUrl64      = $url64
    $selectedChecksum64 = $checksum64
} else {
    throw "No 32-bit installer is published for version $version."
}

if (-not $selectedChecksum64 -or ($selectedChecksum64 -notmatch '^[0-9A-Fa-f]{64}$')) {
    throw "Missing or invalid sha256 checksum format for $selectedUrl64"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url64bit      = $selectedUrl64

  softwareName  = 'voicemeet*'

  checksum64    = $selectedChecksum64
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
