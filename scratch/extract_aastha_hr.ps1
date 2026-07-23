$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Aastha HR Round ---"
for ($i = 5500; $i -lt 5995; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Sushma_HR|Aastha|Sandy):') {
            Write-Host "$($i+1): $line"
            $j = 1
            while ($i + $j -lt 5995) {
                $next = $lines[$i + $j].Trim()
                if ($next -eq "") { $j++; continue }
                if ($next -match '^\d{2}:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
                    break
                }
                Write-Host "      $next"
                $j++
            }
        }
    }
}
