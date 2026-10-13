$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$numberedSpeakers = @("00", "01", "02")
foreach ($num in $numberedSpeakers) {
    Write-Host "`n=== Sample lines for speaker: $num ==="
    $count = 0
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^$num\s*:\s*(.*)") {
            $count++
            if ($count -le 8) {
                Write-Host "Line $($i+1): $($line.Trim())"
            }
        }
    }
}
