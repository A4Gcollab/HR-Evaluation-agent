$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning for interview milestones and transitions ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Sushma_HR|Swetcha):\s*(.*)') {
        $speaker = $Matches[1]
        $text = $Matches[2]
        # Look for name mentions or transition words in their speech
        if ($text -match 'group discussion' -or $text -match 'individual' -or $text -match 'next candidate' -or $text -match 'call' -or $text -match 'interview' -or $text -match 'start with' -or $text -match 'turn' -or $text -match 'thank you' -or ($text -match '\b(Nishad|Jahnavi|Ariti|Sahil|Himanshu|Ayush|Shreya|Anjana)\b' -and $text.Length -lt 200)) {
            Write-Host "Line $($i+1) ($speaker): $text"
        }
    }
}
