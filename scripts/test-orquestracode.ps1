# Testes de integração do ativador OrquestraCode em PowerShell 7+
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$installer = Join-Path $root 'scripts/install-orquestracode.ps1'
$temp = Join-Path ([IO.Path]::GetTempPath()) ("orquestracode-test-" + [guid]::NewGuid().ToString('N'))
[IO.Directory]::CreateDirectory($temp) | Out-Null
try {
    $agents = Join-Path $temp 'AGENTS.md'
    $claude = Join-Path $temp 'CLAUDE.md'
    [IO.File]::WriteAllText($agents, "# Instruções existentes`n", [Text.UTF8Encoding]::new($false))
    & $installer -ProjectPath $temp -DryRun
    if (Test-Path -LiteralPath $claude) { throw 'DryRun criou CLAUDE.md' }
    if ((Get-Content -LiteralPath $agents -Raw) -notmatch 'Instruções existentes') { throw 'DryRun modificou AGENTS.md' }
    & $installer -ProjectPath $temp
    $skill = Join-Path $temp '.orquestracode/skills/full-engineering/SKILL.md'
    if (-not (Test-Path -LiteralPath $skill)) { throw 'Skill não instalada' }
    foreach ($path in @($agents, $claude)) {
        $before = [IO.File]::ReadAllText($path)
        if ($before -notmatch 'ORQUESTRACODE:START' -or $before -notmatch 'ORQUESTRACODE:END') { throw "Marcadores ausentes: $path" }
        & $installer -ProjectPath $temp
        $after = [IO.File]::ReadAllText($path)
        if ($before -cne $after) { throw "Instalação não idempotente: $path" }
    }
    if ((Get-Content -LiteralPath $agents -Raw) -notmatch 'Instruções existentes') { throw 'Conteúdo original perdido' }
    $original = [IO.File]::ReadAllText($agents)
    [IO.File]::WriteAllText($agents, '<!-- ORQUESTRACODE:START -->', [Text.UTF8Encoding]::new($false))
    $failed = $false
    try { & $installer -ProjectPath $temp 2>$null } catch { $failed = $true }
    if (-not $failed) { throw 'Marcador inválido deveria falhar' }
    [IO.File]::WriteAllText($agents, $original, [Text.UTF8Encoding]::new($false))
    Write-Host 'Testes OrquestraCode: aprovados'
}
finally {
    if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
}
