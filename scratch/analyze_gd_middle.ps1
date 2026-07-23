$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning Speakers: Lines 1700 to 2770 ---"
$activeSpeakers = @{}
for ($i = 1700; $i -lt 2770; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
            $speaker = $Matches[1].Trim()
            $activeSpeakers[$speaker] = $activeSpeakers[$speaker] + 1
        }
    }
}

$activeSpeakers.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
    Write-Host "  $($_.Key): $($_.Value)"
}
