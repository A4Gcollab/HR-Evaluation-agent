$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning GD dialog (lines 1 to 1195) ---"
for ($i = 0; $i -lt 1195; $i++) {
    $line = $lines[$i]
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        $text = $Matches[2].Trim()
        if ($speaker -ne "Sushma_HR" -and $speaker -ne "WEBVTT") {
            Write-Host "Line $($i+1) ($speaker): $text"
        }
    }
}
