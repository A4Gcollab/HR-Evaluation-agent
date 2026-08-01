$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$count = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^Swetcha:') {
        $count++
        Write-Host "$($i+1): $line"
        # Print next few lines
        for ($j = 1; $j -le 4; $j++) {
            if ($i + $j -lt $lines.Length) {
                Write-Host "   $($lines[$i+$j].Trim())"
            }
        }
    }
}
