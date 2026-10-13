$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning speakers between 1357 and 1581 ---"
for ($i = 1357; $i -lt 1581; $i++) {
    $line = $lines[$i]
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        $text = $Matches[2].Trim()
        if ($speaker -ne "Sushma_HR" -and $speaker -ne "WEBVTT") {
            Write-Host "Line $($i+1) ($speaker): $text"
        }
    }
}
