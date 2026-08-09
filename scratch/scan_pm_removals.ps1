$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match 'moving forward|leave|appreciate|thank you|sorry') {
        if ($line -match 'Sushma:|Suhani:|Suhani_HR:') {
            Write-Host "$($i+1): $line"
        }
    }
}
