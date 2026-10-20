# Zip every skill into dist/<name>.zip, ready to upload on claude.ai (Settings > Skills).
$ErrorActionPreference = 'Stop'
$skills = Join-Path $PSScriptRoot 'skills'
$dist = Join-Path $PSScriptRoot 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
$tar = Join-Path $env:SystemRoot 'System32\tar.exe'

node (Join-Path $PSScriptRoot 'scripts\check-skills.mjs') $skills
if ($LASTEXITCODE -ne 0) { throw 'A skill breaks the claude.ai upload rules; fix it before packaging.' }

foreach ($skill in Get-ChildItem $skills -Directory) {
    $zip = Join-Path $dist "$($skill.Name).zip"
    Remove-Item $zip -ErrorAction SilentlyContinue
    # tar writes forward-slash entry names; PowerShell 5.1's Compress-Archive can write backslashes.
    & $tar -a -cf $zip -C $skills $skill.Name
    if ($LASTEXITCODE -ne 0) { throw "tar failed for $($skill.Name)" }
    Write-Host "packaged $($skill.Name) -> dist\$($skill.Name).zip"
}
