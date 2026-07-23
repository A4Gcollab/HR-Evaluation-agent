$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidates = @("Riddhi Agarwal", "Disha Sodhani", "Nitish chaudhary", "Ranjana Sharma", "Garima", "sneha", "Olivia Giri", "Shrobana Sarkar", "Sujitha S", "Ananya Yadav", "Riya", "anam anwar", "ashi", "PEARL", "Shivaansh", "Sneha Patil", "Anisha Pati")

Write-Host "--- Scanning for mentions of other candidates by Sushma ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Sushma|Sandy):') {
        foreach ($cand in $candidates) {
            $firstName = $cand.Split(" ")[0]
            if ($line -like "*$firstName*") {
                Write-Host "Line $($i+1): $($line.Trim())"
            }
        }
    }
}

Write-Host "`n--- Scanning for 'remove' or 'leave' or 'left' or video-off warnings ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Sushma|Sandy):' -and ($line -like "*remove*" -or $line -like "*leave*" -or $line -like "*turn on*" -or $line -like "*video*")) {
        Write-Host "Line $($i+1): $($line.Trim())"
    }
}
