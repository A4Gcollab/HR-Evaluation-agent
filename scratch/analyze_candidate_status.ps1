$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidates = @("MONOJ KUMAR MALI", "ROHIT SHAW", "bhawna tyagi", "kaushik ranjan")

foreach ($c in $candidates) {
    Write-Host "`n=================================================="
    Write-Host "Analyzing candidate: $c"
    Write-Host "=================================================="
    
    # Let's count how many times they speak in total
    $speakCount = 0
    # Let's find their first and last speech line
    $firstLine = 0
    $lastLine = 0
    
    $rounds = @()
    
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
    
    # Check if they are mentioned by Sushma or Swetcha
    Write-Host "--- Mentions of their name in the transcript ---"
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "Sushma:" -or $line -match "Swetcha:") {
            if ($line -match $c.Split(" ")[0]) {
                Write-Host "Line $($i+1): $line"
            }
        }
    }
}
