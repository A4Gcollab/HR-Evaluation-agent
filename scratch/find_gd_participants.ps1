$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakers = @{}
for ($i = 0; $i -lt 2900; $i++) {
    $line = $lines[$i]
    if ($line -match '^([A-Za-z\s]+):') {
        $speaker = $Matches[1].Trim()
        if ($speaker -ne "Sushma" -and $speaker -ne "Sandy" -and $speaker -ne "Suhani" -and $speaker -ne "Suhani Rajoura") {
            $speakers[$speaker] = $speakers[$speaker] + 1
        }
    }
}

Write-Host "GD Speakers and line counts:"
$speakers.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
    Write-Host "  $($_.Key): $($_.Value)"
}
