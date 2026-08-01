$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "=== Bhawna Tyagi dialogue ==="
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match 'bhawna|bhawana|tyagi') {
        Write-Host "$($i+1): $line"
        # Print next 3 lines
        for ($j = 1; $j -le 3; $j++) {
            if ($i + $j -lt $lines.Length) {
                Write-Host "   $($lines[$i+$j].Trim())"
            }
        }
    }
}
