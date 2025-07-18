# Development

# Install

```powershell
choco install au
```

# Build

```powershell
choco pack .\manual\voicemeet\voicemeet.nuspec
```

# Local Install

```powershell
# Run as admini
choco install voicemeet --pre --version="0.0.1-beta1" --source="C:\Users\ying\workspace\VoiceMeet\chocolatey-packages"
```

# Push

```powershell
choco push .\voicemeet.0.0.1-beta1.nupkg --api-key=<api key> --source https://push.chocolatey.org/ -d
```
