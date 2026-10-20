# Import this repo's CLAUDE.md into ~/.claude/CLAUDE.md, so the studio rules are always loaded on this machine.
# Skills are not linked: they come from the claude.ai account (synced into ~/.claude/skills/synced/).
$ErrorActionPreference = 'Stop'
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
