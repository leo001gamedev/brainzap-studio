# Junction every skill in this repo into ~/.claude/skills.
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
