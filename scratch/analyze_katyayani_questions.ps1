$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Katyayani Sandy Questions ---"
for ($i = 4370; $i -lt 4620; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Sandy|Katyayani|katyayani):') {
            Write-Host "$($i+1): $line"
        }
    }
}
