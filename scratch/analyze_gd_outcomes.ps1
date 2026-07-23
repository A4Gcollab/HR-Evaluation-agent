$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

# Look for Suhani or Sushma discussing selection or outcomes between line 1300 and 2800
Write-Host "--- Scanning for Interviewer Discussions on GD Outcomes ---"
for ($i = 1300; $i -lt 2800; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Suhani|Sushma_HR|Sushma|Sandy):' -or $line -like "*remove*" -or $line -like "*leave*" -or $line -like "*shortlist*") {
            Write-Host "$($i+1): $line"
        }
    }
}
