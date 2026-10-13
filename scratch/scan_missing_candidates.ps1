$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning for any mention of Anjana or Shreya after line 200 ---"
for ($i = 200; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '(Anjana|Shreya)') {
        Write-Host "Line $($i+1): $line"
    }
}
