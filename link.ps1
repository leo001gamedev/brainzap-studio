# Junction every skill in this repo into ~/.claude/skills, and import CLAUDE.md into ~/.claude/CLAUDE.md.
$ErrorActionPreference = 'Stop'
$target = Join-Path $HOME '.claude\skills'
New-Item -ItemType Directory -Force $target | Out-Null

foreach ($skill in Get-ChildItem (Join-Path $PSScriptRoot 'skills') -Directory) {
    $link = Join-Path $target $skill.Name
    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.LinkType -eq 'Junction' -and $item.Target -contains $skill.FullName) {
            Write-Host "ok      $($skill.Name)"
        } else {
            Write-Warning "skipped $($skill.Name): $link exists and is not a junction to this repo"
        }
        continue
    }
    cmd /c mklink /J "$link" "$($skill.FullName)" | Out-Null
    Write-Host "linked  $($skill.Name)"
}

# Import the studio CLAUDE.md from the user-level one, which every project loads.
$userClaude = Join-Path $HOME '.claude\CLAUDE.md'
$import = '@' + ((Join-Path $PSScriptRoot 'CLAUDE.md') -replace '\\', '/')
$existing = if (Test-Path $userClaude) { Get-Content $userClaude } else { @() }
if ($existing -contains $import) {
    Write-Host "ok      CLAUDE.md import"
} else {
    # No BOM: PowerShell 5.1's utf8 adds one, which hides the '@' of a first-line import.
    [IO.File]::AppendAllText($userClaude, "$import`n", (New-Object Text.UTF8Encoding $false))
    Write-Host "added   CLAUDE.md import to $userClaude"
}
