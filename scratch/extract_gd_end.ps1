$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

Write-Host "=== Dialogue from line 755 to 820 ==="
for ($i = 754; $i -lt 820; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line.Trim() -ne "") {
            Write-Host "$($i+1): $line"
        }
    }
}
