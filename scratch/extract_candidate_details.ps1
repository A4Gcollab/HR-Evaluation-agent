$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

function Extract-Speaker-Context($speakerName) {
    Write-Host "`n========================================="
    Write-Host "CONTEXT FOR $speakerName"
    Write-Host "========================================="
    $count = 0
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        # Match lines where the speaker speaks or is spoken to (name appears in Sushma's/Swetcha's lines)
        if ($line -match "^$speakerName\s*:") {
            # Print the timestamp above
            if ($i -gt 1 -and $lines[$i-1] -match '-->') {
                Write-Host $lines[$i-1].Trim()
            }
            Write-Host $line.Trim()
            # print next few lines until empty or next speaker/timestamp
            $j = 1
            while ($i + $j -lt $lines.Length) {
                $next = $lines[$i+$j].Trim()
                if ($next -eq "") { $j++; continue }
                if ($next -match '^\d+:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
                    break
                }
                Write-Host "   $next"
                $j++
            }
        }
    }
}

Extract-Speaker-Context "MONOJ KUMAR MALI"
Extract-Speaker-Context "ROHIT SHAW"
