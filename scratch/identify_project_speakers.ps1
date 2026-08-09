$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

$speakers = @{}
foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -and $line.Contains(":") -and -not $line.StartsWith("http") -and -not $line.StartsWith("00:") -and -not $line.StartsWith("01:")) {
        $parts = $line.Split(":", 2)
        $speaker = $parts[0].Trim()
        if ($speaker.Length -gt 1 -and $speaker.Length -lt 40) {
            $speakers[$speaker]++
        }
    }
}

Write-Host "Found speakers and line counts:"
foreach ($s in $speakers.Keys | Sort-Object) {
    Write-Host "- $s : $($speakers[$s]) lines"
}
