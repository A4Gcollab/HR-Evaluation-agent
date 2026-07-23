$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$numberedSpeakers = @("00", "01", "02", "03")
foreach ($num in $numberedSpeakers) {
    Write-Host "`n=== Sample lines for speaker: $num ==="
    $count = 0
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^$num\s*:") {
            $count++
            if ($count -le 10) {
                Write-Host "Line $($i+1): $($line.Trim())"
                # Print the next non-empty line
                $j = 1
                while ($i + $j -lt $lines.Length -and $lines[$i+$j].Trim() -eq "") {
                    $j++
                }
                if ($i + $j -lt $lines.Length) {
                    Write-Host "      $($lines[$i+$j].Trim())"
                }
            }
        }
    }
}
