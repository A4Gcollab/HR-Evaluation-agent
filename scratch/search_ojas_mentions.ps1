$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

$lineNum = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match 'Ojas|Ojus') {
        Write-Host "$lineNum : $line"
    }
}
