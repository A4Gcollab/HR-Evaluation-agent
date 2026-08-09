$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260809-072800_PM-2.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$outLines = @()
for ($i = 0; $i -lt $lines.Length; $i++) {
    $outLines += $lines[$i]
}

$outPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\harshita_interview_full.txt"
$outLines | Out-File -FilePath $outPath -Encoding utf8
Write-Host "Harshita interview extracted to: $outPath"
