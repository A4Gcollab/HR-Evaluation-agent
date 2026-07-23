$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidateInterviews = @{}
$currentCandidate = $null
$startLine = $null

Write-Host "--- Scanning post-GD transcript for candidate speaking blocks ---"
for ($i = 2900; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^([A-Za-z\s]+):') {
        $speaker = $Matches[1].Trim()
        if ($speaker -ne "Sushma" -and $speaker -ne "Sandy" -and $speaker -ne "Suhani" -and $speaker -ne "Suhani Rajoura") {
            # This is likely a candidate
            if ($currentCandidate -ne $speaker) {
                if ($currentCandidate -ne $null) {
                    Write-Host "Candidate $currentCandidate spoke from line $startLine to $i"
                }
                $currentCandidate = $speaker
                $startLine = $i
            }
        }
    }
}
if ($currentCandidate -ne $null) {
    Write-Host "Candidate $currentCandidate spoke from line $startLine to $($lines.Length)"
}
