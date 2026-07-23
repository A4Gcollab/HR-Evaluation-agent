$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning for Vanshita mentions ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*Vanshita*" -or $line -like "*VANSHITA*") {
        Write-Host "Line $($i+1): $($line.Trim())"
    }
}
