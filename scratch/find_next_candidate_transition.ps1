$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning Transitions: Lines 3700 to 4000 ---"
for ($i = 3700; $i -lt 4000; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Suhani|Sushma_HR|Sushma|Sandy|Katyayani|katyayani|Ruchira):' -or $line -like "*moving*" -or $line -like "*room*" -or $line -like "*next*") {
            Write-Host "$($i+1): $line"
        }
    }
}
