$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$count = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^01:') {
        $count++
        Write-Host "Line $($i+1): $line"
        # Print next 5 lines
        for ($j = 1; $j -le 5; $j++) {
            if ($i + $j -lt $lines.Length) {
                Write-Host "   $($lines[$i+$j].Trim())"
            }
        }
        if ($count -ge 10) { break }
    }
}
