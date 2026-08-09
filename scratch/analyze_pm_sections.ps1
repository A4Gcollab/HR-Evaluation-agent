$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidates = @("Sachindra", "Isha", "Harshita", "vivek", "Priyanka")

Write-Host "--- Scanning for candidate name mentions by interviewers ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -eq "WEBVTT" -or $line -match '^\d+$' -or $line -match '-->') { continue }
    
    if ($line -match '^(Sushma|Swetcha):') {
        foreach ($c in $candidates) {
            if ($line -match $c) {
                Write-Host "Line $($i+1): $line"
            }
        }
    }
}

Write-Host "`n--- Scanning for round mentions (GD, HR, Natural Fit, Org Fit) ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -eq "WEBVTT" -or $line -match '^\d+$' -or $line -match '-->') { continue }
    
    if ($line -match 'group discussion|GD|HR round|natural fit|org fit|organizational fit|fitment') {
        Write-Host "Line $($i+1): $line"
    }
}
