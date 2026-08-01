$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match 'moving forward|leave|appreciate your time|thank you|sorry') {
        if ($line -match 'Sushma:|Swetcha:') {
            Write-Host "$($i+1): $line"
        }
    }
}
