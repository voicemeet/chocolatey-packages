# Development

## Install

```powershell
choco install au
```

## Upgrade

```powershell
cd .\automatic\voicemeet
.\update.ps1
```

## Build

```powershell
choco pack .\automatic\voicemeet\voicemeet.nuspec
```

## Local Install

```powershell
# Run as Administrator
choco install voicemeet --pre --version="0.0.1-rc0" --source="C:\Users\ying\workspace\VoiceMeet\chocolatey-packages"
```

## Push

```powershell
choco push .\voicemeet.0.0.1-rc0.nupkg --api-key=<api key> --source https://push.chocolatey.org/ -d
```
