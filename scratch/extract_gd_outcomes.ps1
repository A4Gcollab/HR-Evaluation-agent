$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

Write-Host "=== GD Outcomes (Lines 1050 to 1120) ==="
for ($i = 1050; $i -lt 1120; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line.Trim() -ne "") {
            Write-Host "$($i+1): $line"
        }
    }
}
