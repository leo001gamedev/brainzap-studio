# Zip every skill into dist/<name>-<short sha>.zip, ready to upload on claude.ai (Settings > Skills).
# The sha says which commit the zip came from; '-dirty' means it includes uncommitted skill changes.
$ErrorActionPreference = 'Stop'
$skills = Join-Path $PSScriptRoot 'skills'
$dist = Join-Path $PSScriptRoot 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
$tar = Join-Path $env:SystemRoot 'System32\tar.exe'
$sha = (git -C $PSScriptRoot rev-parse --short=7 HEAD).Trim()
if (git -C $PSScriptRoot status --porcelain -- skills) { $sha = "$sha-dirty" }

node (Join-Path $PSScriptRoot 'scripts\check-skills.mjs') $skills
if ($LASTEXITCODE -ne 0) { throw 'A skill breaks the claude.ai upload rules; fix it before packaging.' }

# Old zips from other commits would be easy to upload by mistake.
Remove-Item (Join-Path $dist '*.zip') -ErrorAction SilentlyContinue

foreach ($skill in Get-ChildItem $skills -Directory) {
    $zip = Join-Path $dist "$($skill.Name)-$sha.zip"
    # tar writes forward-slash entry names; PowerShell 5.1's Compress-Archive can write backslashes.
    & $tar -a -cf $zip -C $skills $skill.Name
    if ($LASTEXITCODE -ne 0) { throw "tar failed for $($skill.Name)" }
    Write-Host "packaged $($skill.Name) -> dist\$($skill.Name)-$sha.zip"
}
