$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$currentCandidate = $null
$startLine = 0

Write-Host "--- Scanning transcript for candidate speaking blocks ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        # Clean up speaker name if it has formatting
        $speakerClean = $speaker -replace '[:\s\(\)\d\?]+$', ''
        if ($speakerClean -ne "Sushma_HR" -and $speakerClean -ne "Swetcha" -and $speakerClean -ne "WEBVTT") {
            if ($currentCandidate -ne $speakerClean) {
                if ($currentCandidate -ne $null) {
                    Write-Host "Candidate $currentCandidate spoke from line $startLine to $i"
                }
                $currentCandidate = $speakerClean
                $startLine = $i
            }
        }
    }
}
if ($currentCandidate -ne $null) {
    Write-Host "Candidate $currentCandidate spoke from line $startLine to $($lines.Length)"
}
