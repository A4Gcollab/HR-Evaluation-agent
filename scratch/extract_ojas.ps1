$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

Write-Host "=== Ojas Khetarpal Dialogue ==="
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^Ojas Khetarpal:') {
        Write-Host "$($i+1): $line"
        # Print next 2 lines
        for ($j = 1; $j -le 2; $j++) {
            if ($i + $j -lt $lines.Length) {
                Write-Host "   $($lines[$i+$j].Trim())"
            }
        }
    }
}
