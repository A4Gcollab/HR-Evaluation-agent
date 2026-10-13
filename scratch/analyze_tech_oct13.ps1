$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakerCounts = @{}
$speakerFirst = @{}
$speakerLast = @{}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^([^:\n]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        if (-not $speakerCounts.ContainsKey($speaker)) {
            $speakerCounts[$speaker] = 0
            $speakerFirst[$speaker] = $i
        }
        $speakerCounts[$speaker]++
        $speakerLast[$speaker] = $i
    }
}

Write-Host "Total lines: $($lines.Length)"
Write-Host "Speakers found:"
$sortedSpeakers = $speakerFirst.GetEnumerator() | Sort-Object Value
foreach ($item in $sortedSpeakers) {
    $spk = $item.Key
    Write-Host "$spk | Count: $($speakerCounts[$spk]) | First line: $($speakerFirst[$spk]) | Last line: $($speakerLast[$spk])"
}
