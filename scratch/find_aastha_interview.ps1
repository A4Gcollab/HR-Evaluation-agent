$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning Transitions: Lines 5500 to 6200 ---"
for ($i = 5500; $i -lt 6200; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Suhani|Sushma_HR|Sushma|Sandy|Aastha|aastha):' -or $line -like "*moving*" -or $line -like "*room*" -or $line -like "*next*" -or $line -like "*join*") {
            Write-Host "$($i+1): $line"
        }
    }
}
