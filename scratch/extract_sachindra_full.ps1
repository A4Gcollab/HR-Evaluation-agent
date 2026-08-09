$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$outLines = @()
for ($i = 1720; $i -lt 2850; $i++) {
    if ($i -lt $lines.Length) {
        $outLines += $lines[$i]
    }
}

$outPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\sachindra_interview_full.txt"
$outLines | Out-File -FilePath $outPath -Encoding utf8
Write-Host "Sachindra interview extracted to: $outPath"
