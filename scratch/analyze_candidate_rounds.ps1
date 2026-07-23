$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$ranges = @(
    @{Name = "Bhumika K"; Start = 2940; End = 3780},
    @{Name = "Swetcha"; Start = 3780; End = 4548},
    @{Name = "Sowmiya K R"; Start = 4548; End = 5112},
    @{Name = "yashna"; Start = 5112; End = 5536},
    @{Name = "Eshita Singh"; Start = 5536; End = 5882}
)

foreach ($r in $ranges) {
    Write-Host "`n======================================================="
    Write-Host "Candidate: $($r.Name) (Lines $($r.Start) - $($r.End))"
    Write-Host "======================================================="
    
    # Print lines where Sandy speaks or Sushma transitions, and context lines
    $lastSpeaker = ""
    for ($i = $r.Start; $i -lt $r.End; $i++) {
        $line = $lines[$i]
        if ($line -match '^([A-Za-z\s]+):') {
            $speaker = $Matches[1].Trim()
            if ($speaker -eq "Sandy" -or $speaker -eq "Sushma" -or $speaker -eq "Suhani") {
                if ($lastSpeaker -ne $speaker) {
                    Write-Host "  Line $($i+1) [$speaker]: $($line.Trim())"
                    # Print next 3 lines for context
                    $j = 1
                    while ($j -lt 5 -and $i + $j -lt $r.End) {
                        $nextLine = $lines[$i+$j].Trim()
                        if ($nextLine -ne "" -and $nextLine -notmatch '^\d{2}:\d{2}:') {
                            Write-Host "      $nextLine"
                        }
                        $j++
                    }
                    $lastSpeaker = $speaker
                }
            } else {
                $lastSpeaker = $speaker
            }
        }
    }
}
