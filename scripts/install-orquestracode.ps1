# OrquestraCode — ativador da camada Full Engineering
# Executar a partir do clone local do fork. Não altera o instalador FCC original.
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$InstallFcc,
    [switch]$DryRun
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$skillSource = Join-Path $root 'skills/full-engineering/SKILL.md'
if (-not (Test-Path -LiteralPath $skillSource -PathType Leaf)) {
    throw "Skill não encontrada: $skillSource. Execute a partir do clone completo."
}
if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "Diretório de projeto inexistente: $ProjectPath"
}
$project = (Resolve-Path -LiteralPath $ProjectPath).Path
$skillTarget = Join-Path $project '.orquestracode/skills/full-engineering/SKILL.md'
$instruction = @'
## OrquestraCode Full Engineering
Antes de alterar código, leia `.orquestracode/skills/full-engineering/SKILL.md`.
Aplique seus critérios de investigação, segurança, testes, revisão e evidências.
Estas instruções complementam as demais regras deste projeto.
'@
function Write-ManagedInstructions {
    param([string]$Path)
    $start = '<!-- ORQUESTRACODE:START -->'
    $end = '<!-- ORQUESTRACODE:END -->'
    $block = "$start`n$instruction`n$end"
    $existing = if (Test-Path -LiteralPath $Path) { [IO.File]::ReadAllText($Path) } else { '' }
    $startIndex = $existing.IndexOf($start, [StringComparison]::Ordinal)
    $endIndex = $existing.IndexOf($end, [StringComparison]::Ordinal)
    if (($startIndex -ge 0) -xor ($endIndex -ge 0)) {
        throw "Marcadores inconsistentes em $Path. Corrija manualmente antes de prosseguir."
    }
    if ($startIndex -ge 0) {
        if ($endIndex -lt $startIndex) { throw "Marcadores invertidos em $Path" }
        $tail = $endIndex + $end.Length
        $updated = $existing.Substring(0, $startIndex) + $block + $existing.Substring($tail)
    } else {
        $separator = if ($existing.Length -gt 0 -and -not $existing.EndsWith("`n")) { "`n`n" } elseif ($existing.Length -gt 0) { "`n" } else { '' }
        $updated = $existing + $separator + $block + "`n"
    }
    if ($DryRun) { Write-Host "[Simulação] Atualizar $Path"; return }
    if ($updated -eq $existing) { Write-Host "Sem alterações: $Path"; return }
    [IO.File]::WriteAllText($Path, $updated, [Text.UTF8Encoding]::new($false))
    Write-Host "Atualizado: $Path"
}
if ($InstallFcc) {
    $installer = Join-Path $root 'scripts/install.ps1'
    if (-not (Test-Path -LiteralPath $installer -PathType Leaf)) { throw "Instalador FCC ausente: $installer" }
    if ($DryRun) {
        Write-Host "[Simulação] Executar instalador FCC com -DryRun"
    } elseif ($PSCmdlet.ShouldProcess('FCC', 'Executar instalador original, que poderá baixar dependências externas')) {
        & $installer
        if (-not $?) { throw 'O instalador FCC falhou.' }
    }
}
if ($DryRun) {
    Write-Host "[Simulação] Copiar $skillSource para $skillTarget"
} elseif ($PSCmdlet.ShouldProcess($project, 'Instalar camada Full Engineering')) {
    $targetDir = Split-Path -Parent $skillTarget
    [IO.Directory]::CreateDirectory($targetDir) | Out-Null
    Copy-Item -LiteralPath $skillSource -Destination $skillTarget -Force
}
foreach ($name in @('AGENTS.md', 'CLAUDE.md')) {
    $target = Join-Path $project $name
    if ($DryRun -or $PSCmdlet.ShouldProcess($target, 'Adicionar instruções gerenciadas')) {
        Write-ManagedInstructions -Path $target
    }
}
Write-Host 'OrquestraCode: camada configurada. Valide o carregamento das instruções no agente.'
