$txtFile = "Project Management Interviews's transcript.txt"
$lines = Get-Content $txtFile -Encoding utf8
$lineNum = 0
$results = @()

foreach ($line in $lines) {
    $lineNum++
    if ($line -match '^Sushma:\s+Hi\s+(\w+)' -or $line -match '^Suhani:\s+Hi\s+(\w+)' -or $line -match '^Sushma:\s+(\w+),\s+are you there' -or $line -match 'moving forward with you') {
        $results += "$lineNum : $line"
    }
}
$results
