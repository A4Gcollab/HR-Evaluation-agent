$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakers = @{}
$sampleLines = @{}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if (-not $line) { continue }
    if ($line -eq "WEBVTT" -or $line -match '^\d+$' -or $line -match '-->') { continue }
    
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        $text = $Matches[2].Trim()
        
        $speakers[$speaker] = $speakers[$speaker] + 1
        if (-not $sampleLines.ContainsKey($speaker)) {
            $sampleLines[$speaker] = @()
        }
        if ($sampleLines[$speaker].Count -lt 2) {
            $sampleLines[$speaker] += "Line $($i+1): $text"
        }
    }
}

Write-Host "Speakers and line counts:"
foreach ($sp in $speakers.Keys | Sort-Object { $speakers[$_] } -Descending) {
    Write-Host "- $sp : $($speakers[$sp]) lines"
}

Write-Host "`nSample lines for each speaker:"
foreach ($sp in $speakers.Keys | Sort-Object) {
    Write-Host "=== $sp ==="
    foreach ($sample in $sampleLines[$sp]) {
        Write-Host $sample
    }
}
