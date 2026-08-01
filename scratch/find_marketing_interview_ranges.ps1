$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8
$lineNum = 0
$results = @()

foreach ($line in $lines) {
    $lineNum++
    if ($line -match 'Sushma:' -or $line -match 'Suhani:' -or $line -match 'Nausheen:') {
        if ($line -match 'Hi|hello|welcome|round|evaluation|next|moving|breakout|stipend|confirm|availability|commit|marketing|audible|joined' -or $line.Length -lt 80) {
            $results += "$lineNum : $line"
        }
    }
}

Write-Host "Total matching lines: $($results.Count)"
# Print first 100 matching lines to see what's happening
$results[0..150] | ForEach-Object { Write-Host $_ }
