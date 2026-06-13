$ErrorActionPreference = 'Stop'
import-module chocolatey-au

# add headers
$headers = @{
    "Authorization" = "Bearer $Env:VM_RELEASE_TOKEN"
    "Content-Type"  = "application/json"
}

function Get-RemoteFileSha256 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$FileUrl,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$TempPath = "$env:TEMP\temp_hash_file.exe"
    )

    try {
        Write-Verbose "Downloading files from a URL: $FileUrl"
        # 1. Download the file to the specified temporary path
        Invoke-WebRequest -Method Get -Headers $headers -Uri $FileUrl -OutFile $TempPath -ErrorAction Stop

        Write-Verbose "Download complete, now calculating the SHA256 hash value..."
        # 2. Calculate SHA256 and convert it to a pure lowercase string
        $Sha256 = (Get-FileHash -Path $TempPath -Algorithm SHA256).Hash.ToLower()

        # 3. Return results
        return $Sha256
    }
    catch {
        # Catch exceptions and throw them to help upper-level callers know the error
        Throw "File Hash Failed! Reasons for errors: $_"
    }
    finally {
        # 4. Whether successful or not, as long as the temporary file exists, cleanup is performed
        if (Test-Path $TempPath) {
            Write-Verbose "Cleaning up temporary files: $TempPath"
            Remove-Item $TempPath -Force
        }
    }
}

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/voicemeet/app/releases/latest" -Headers $headers
    $LatestVersion = $LatestRelease.tag_name.Replace('v', '').Replace('+', '.')
    $LatestURL64 = ($LatestRelease.assets | Where-Object {$_.name.EndsWith("-windows-setup-x64.exe")}).browser_download_url
    $LatestURLArm64 = ($LatestRelease.assets | Where-Object {$_.name.EndsWith("-windows-setup-arm64.exe")}).browser_download_url

    if (!$LatestURL64) {
        throw "64bit URL is missing!"
    }

    if (!$LatestURLArm64) {
        throw "Arm64 URL is missing!"
    }

    $LatestChecksum64    = Get-RemoteFileSha256 -FileUrl $LatestURL64 -TempPath "$env:TEMP\voicemeet-$($LatestVersion)-windows-setup-x64.exe"
    $LatestChecksumArm64 = Get-RemoteFileSha256 -FileUrl $LatestURLArm64 -TempPath "$env:TEMP\voicemeet-$($LatestVersion)-windows-setup-arm64.exe"

    Write-Output "newversion=$($LatestVersion)" >> $Env:GITHUB_OUTPUT

    @{
        URL64          = $LatestURL64
        URLArm64       = $LatestURLArm64
        Checksum64     = $LatestChecksum64
        checksumArm64  = $LatestChecksumArm64
        Version        = $LatestVersion
        ReleaseNotes   = $LatestRelease.html_url
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url64\s*=\s*)('.*')"       = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*(\$)urlArm64\s*=\s*)('.*')"    = "`$1'$($Latest.URLArm64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"      = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumArm64\s*=\s*)('.*')"   = "`$1'$($Latest.checksumArm64)'"
        }

        "voicemeet.nuspec" = @{
            "(\<version\>).*?(\</version\>)"           = "`${1}$($Latest.Version)`$2"
#            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

update -ChecksumFor none
