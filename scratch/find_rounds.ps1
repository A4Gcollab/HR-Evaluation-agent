$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning for round boundaries ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*group discussion*" -or $line -like "*GD*" -or $line -like "*HR round*" -or $line -like "*fit round*" -or $line -like "*natural fit*" -or $line -like "*org fit*" -or $line -like "*organizational fit*") {
        if ($line.Length -gt 15) {
            $snippet = $line.SubString(0, [Math]::Min(150, $line.Length))
            Write-Host "Line $($i+1): $($snippet.Trim())"
        }
    }
}

Write-Host "`n--- Scanning for candidate transitions / interviews ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match "^(Sushma|Suhani|Sandy|Raghil Ramachandran|Aastha):") {
        if ($line -like "*congratulations*" -or $line -like "*moving forward*" -or $line -like "*next round*" -or $line -like "*select*" -or $line -like "*shortlist*" -or $line -like "*welcome*") {
            $snippet = $line.SubString(0, [Math]::Min(150, $line.Length))
            Write-Host "Line $($i+1): $($snippet.Trim())"
        }
    }
}
