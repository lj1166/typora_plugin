param(
  [string]$OutputPath = (Join-Path $PSScriptRoot "minimal-repro.md")
)

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Typora-Plugin Performance Minimal Reproduction")
$lines.Add("")
$lines.Add("This synthetic document contains 138 fenced code blocks, including 3 Mermaid blocks, and exactly 6,000 lines.")
$lines.Add("")

for ($block = 1; $block -le 138; $block++) {
  $isMermaid = $block -in 20, 70, 120
  if ($isMermaid) {
    $lines.Add('```mermaid')
    $lines.Add("flowchart LR")
    $lines.Add("  A$block[Start] --> B$block[Process]")
    $lines.Add("  B$block --> C$block[End]")
    $lines.Add('```')
  } else {
    $lines.Add('```javascript')
    for ($line = 1; $line -le 38; $line++) {
      $lines.Add("const sample_${block}_${line} = $line; // deterministic filler for code-fence density")
    }
    $lines.Add('```')
  }
  $lines.Add("")
}

$paragraph = 1
while ($lines.Count -lt 6000) {
  $lines.Add("Paragraph ${paragraph}: ordinary Markdown content retained to make the document exactly 6,000 lines without external assets.")
  $paragraph++
}

if ($lines.Count -ne 6000) {
  throw "Expected exactly 6000 lines, got $($lines.Count)."
}

[System.IO.File]::WriteAllLines($OutputPath, $lines, [System.Text.UTF8Encoding]::new($false))
Write-Output "Created $OutputPath with $($lines.Count) lines."
