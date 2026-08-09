$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$outLines = @()
for ($i = 0; $i -lt 1200; $i++) {
    if ($i -lt $lines.Length) {
        $outLines += $lines[$i]
    }
}

$outPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\gd_transcript.txt"
$outLines | Out-File -FilePath $outPath -Encoding utf8
Write-Host "GD transcript extracted to: $outPath"
