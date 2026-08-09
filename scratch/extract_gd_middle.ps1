$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

Write-Host "=== Dialogue around line 1120-1180 ==="
for ($i = 1120; $i -lt 1180; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line.Trim() -ne "") {
            Write-Host "$($i+1): $line"
        }
    }
}
