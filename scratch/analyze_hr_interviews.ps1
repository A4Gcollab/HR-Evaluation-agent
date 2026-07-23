$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8
Write-Host "Total lines: $($lines.Length)"

# Find all speakers and line counts
$speakers = @{}
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^([A-Za-z0-9\s\.\(\)\-\[\]\''_]+):') {
        $speaker = $Matches[1].Trim()
        $speakers[$speaker] = $speakers[$speaker] + 1
    }
}

Write-Host "`nSpeakers and their line counts:"
$speakers.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 40 | ForEach-Object {
    Write-Host "  $($_.Key): $($_.Value)"
}

Write-Host "`n--- Scanning for round-like references ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match 'group discussion|GD|HR round|fit round|natural fit|org fit|organizational fit|individual interview|personal interview') {
        Write-Host "Line $($i+1): $($line.Trim())"
    }
}

Write-Host "`n--- Scanning for candidate transitions / interviews ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Sushma|Suhani):') {
        if ($line -match 'onboard|welcome|congratulate|next candidate|call the|please start|your turn|individual|interview') {
            Write-Host "Line $($i+1): $($line.Trim())"
        }
    }
}
