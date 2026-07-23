$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

Write-Host "--- Ruchira HR Round ---"
for ($i = 2800; $i -lt 3260; $i++) {
    if ($i -lt $lines.Length) {
        $line = $lines[$i]
        if ($line -match '^(Sushma_HR|Ruchira\.|Sandy):') {
            Write-Host "$($i+1): $line"
            # print next lines
            for ($j = 1; $j -le 3; $j++) {
                if ($i + $j -lt $lines.Length) {
                    $next = $lines[$i + $j].Trim()
                    if ($next -ne "" -and $next -notmatch '^\d{2}:\d{2}:') {
                        Write-Host "      $next"
                    }
                }
            }
        }
    }
}
