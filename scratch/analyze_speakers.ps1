$txtFile = "Project Management Interviews's transcript.txt"
$lines = Get-Content $txtFile -Encoding utf8
$speakers = @{}
$lineNum = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match '^([A-Za-z\s]+):') {
        $speaker = $Matches[1].Trim()
        if (-not $speakers.ContainsKey($speaker)) {
            $speakers[$speaker] = @{ Count = 0; FirstLine = $lineNum; LastLine = $lineNum }
        }
        $speakers[$speaker].Count++
        $speakers[$speaker].LastLine = $lineNum
    }
}
foreach ($key in $speakers.Keys) {
    Write-Host "$key : Count=$($speakers[$key].Count), FirstLine=$($speakers[$key].FirstLine), LastLine=$($speakers[$key].LastLine)"
}
