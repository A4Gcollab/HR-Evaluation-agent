$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

$candidates = @("Atif", "Mufiz ansari", "Ojas Khetarpal", "Pranjal Singh", "Rani Parihar Thakur", "ROOLI", "Saikumar Datla")

foreach ($c in $candidates) {
    Write-Host "`n=================================================="
    Write-Host "Analyzing candidate: $c"
    Write-Host "=================================================="
    
    $speakCount = 0
    $firstLine = 0
    $lastLine = 0
    
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^$c\s*:") {
            $speakCount++
            if ($firstLine -eq 0) { $firstLine = $i + 1 }
            $lastLine = $i + 1
        }
    }
    
    Write-Host "Total speech blocks: $speakCount"
    Write-Host "First spoke at line: $firstLine"
    Write-Host "Last spoke at line: $lastLine"
    
    Write-Host "--- Mentions of their name by Sushma/Suhani ---"
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match '^(Sushma|Suhani|Suhani_HR):') {
            if ($line -match $c.Split(" ")[0]) {
                Write-Host "Line $($i+1): $line"
            }
        }
    }
}
