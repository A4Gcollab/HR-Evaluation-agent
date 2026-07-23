$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$ranges = @(
    @{Name = "Bhumika K"; Start = 2940; End = 3388},
    @{Name = "Swetcha"; Start = 3780; End = 4156},
    @{Name = "Sowmiya K R"; Start = 4548; End = 5072},
    @{Name = "yashna"; Start = 5112; End = 5372},
    @{Name = "Eshita Singh"; Start = 5536; End = 5882}
)

foreach ($r in $ranges) {
    Write-Host "`n======================================================="
    Write-Host "HR Round Dialogue for $($r.Name) (Lines $($r.Start) - $($r.End))"
    Write-Host "======================================================="
    
    # Print lines of Sushma/Candidate in this range
    for ($i = $r.Start; $i -lt $r.End; $i++) {
        $line = $lines[$i]
        if ($line -match '^([A-Za-z\s\._]+):') {
            $speaker = $Matches[1].Trim()
            if ($speaker -eq "Sushma" -or $speaker -eq $r.Name.Split(" ")[0] -or $speaker -eq "Suhani" -or $speaker -eq "yashna" -or $speaker -eq "Eshita Singh") {
                Write-Host "Line $($i+1) [$speaker]: $($line.Trim())"
                # print next lines until timestamp or new speaker
                $j = 1
                while ($i + $j -lt $r.End) {
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
}
