$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "=== HR Round for Bhawna and Kaushik (Lines 1350 to 1755) ==="
for ($i = 1349; $i -lt 1755; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line.Trim() -ne "") {
            Write-Host "$($i+1): $line"
        }
    }
}
