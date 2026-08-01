$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakerCounts = @{}
$speakerFirstLines = @{}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -and $line.Contains(":") -and -not $line.StartsWith("http") -and -not $line.StartsWith("00:") -and -not $line.StartsWith("01:")) {
        $parts = $line.Split(":", 2)
        $speaker = $parts[0].Trim()
        if ($speaker.Length -gt 1 -and $speaker.Length -lt 40) {
            $speakerCounts[$speaker]++
            if (-not $speakerFirstLines.ContainsKey($speaker)) {
                # Find the actual text which is usually on the next line or in the same line
                $text = $parts[1].Trim()
                $speakerFirstLines[$speaker] = "$($i+1): $text"
            }
        }
    }
}

Write-Host "Speaker Counts and First Lines:"
foreach ($s in $speakerCounts.Keys | Sort-Object) {
    Write-Host "$s : $($speakerCounts[$s]) lines"
    Write-Host "   First appearance: $($speakerFirstLines[$s])"
}
