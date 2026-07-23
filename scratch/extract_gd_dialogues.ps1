$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

$candidates = @(
    "Susmita Saha", "Atharva Bhoyar", "Essha Rajput", "Madeeha Abid", 
    "Swastika Jaiswal", "Reshika", "Srishti Ray", "Tushar Soni", 
    "Shubham Sinha", "Lavisha Bhardwaj", "Siddhi Sawant", "vaishali", 
    "Nandini Mishra", "Bhumika chawla", "Ritika-Mehta", "Kritika"
)

foreach ($c in $candidates) {
    Write-Host "`n=================================================="
    Write-Host "GD contributions for $($c)"
    Write-Host "=================================================="
    $count = 0
    # Search GD lines (1 to 1774)
    for ($i = 0; $i -lt 1774; $i++) {
        if ($i -lt $lines.Length) {
            $line = $lines[$i]
            if ($line -match "^$c" -or ($c -eq "vaishali" -and $line -match "^vaishali:")) {
                $count++
                Write-Host "Line $($i+1): $($line.Trim())"
                # print next lines until we hit a timestamp or speaker
                $j = 1
                while ($i + $j -lt 1774) {
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
    Write-Host "Total lines: $count"
}
