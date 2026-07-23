$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8
Write-Host "Total lines: $($lines.Length)"

$speakers = @{}
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
        $speaker = $Matches[1].Trim()
        $speakers[$speaker] = $speakers[$speaker] + 1
    }
}

Write-Host "`nSpeakers and line counts:"
$speakers.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
    Write-Host "  $($_.Key): $($_.Value)"
}

Write-Host "`nKey transitions or introductions:"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*Sushma:*" -or $line -like "*Suhani:*") {
        if ($line.ToLower() -like "*welcome*" -or $line.ToLower() -like "*join*" -or $line.ToLower() -like "*introduce*" -or $line.ToLower() -like "*moving forward*" -or $line.ToLower() -like "*starting*" -or $line.ToLower() -like "*next*") {
            $snippet = $line.SubString(0, [Math]::Min(120, $line.Length))
            Write-Host "Line $($i+1): $($snippet.Trim())"
        }
    }
}
