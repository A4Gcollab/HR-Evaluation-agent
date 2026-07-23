$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Scanning for 'remove' or 'leave' or 'left' ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*remove*" -or $line -like "*leave*" -or $line -like "*leaving*") {
        if ($line.Length -gt 10) {
            $snippet = $line.SubString(0, [Math]::Min(150, $line.Length))
            Write-Host "Line $($i+1): $($snippet.Trim())"
        }
    }
}
