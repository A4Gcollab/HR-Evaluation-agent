$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "=== GD wrap-up and elimination context (Lines 1100 to 1350) ==="
for ($i = 1100; $i -lt 1350; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line.Trim() -ne "") {
            Write-Host "$($i+1): $line"
        }
    }
}
