$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

$numberedSpeakers = @("00", "01", "02", "03")
foreach ($num in $numberedSpeakers) {
    Write-Host "`n=== Sample lines for speaker: $num ==="
    $count = 0
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^$num\s*:") {
            $count++
            if ($count -le 5) {
                Write-Host "Line $($i+1): $($line.Trim())"
                # Print the next non-empty line
                if ($i + 1 -lt $lines.Length) {
                    Write-Host "      $($lines[$i+1].Trim())"
                }
            }
        }
    }
}
