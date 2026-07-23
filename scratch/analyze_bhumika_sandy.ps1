$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning Bhumika K's Sandy Questions ---"
for ($i = 2950; $i -lt 3780; $i++) {
    $line = $lines[$i]
    if ($line -match '^Sandy:') {
        Write-Host "Line $($i+1): $($line.Trim())"
        # Print next 5 lines
        for ($j = 1; $j -le 5; $j++) {
            if ($i + $j -lt 3780) {
                $nextLine = $lines[$i+$j].Trim()
                if ($nextLine -ne "" -and $nextLine -notmatch '^\d{2}:\d{2}:') {
                    Write-Host "      $nextLine"
                }
            }
        }
    }
}
