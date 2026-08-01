$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakers = @{}
foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -and $line.Contains(":") -and -not $line.StartsWith("http") -and -not $line.StartsWith("00:")) {
        $parts = $line.Split(":", 2)
        $speaker = $parts[0].Trim()
        if ($speaker.Length -gt 1 -and $speaker.Length -lt 40) {
            $speakers[$speaker] = $true
        }
    }
}

Write-Host "Found speakers:"
foreach ($s in $speakers.Keys | Sort-Object) {
    Write-Host "- $s"
}
