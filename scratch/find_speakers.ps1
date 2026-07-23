$txtFile = "Project Management Interviews's transcript.txt"
$lines = Get-Content $txtFile -Encoding utf8
$speakers = @{}
foreach ($line in $lines) {
    if ($line -match '^([A-Za-z0-9\s\(\)]+):') {
        $speaker = $Matches[1].Trim()
        $speakers[$speaker] = $true
    }
}
$speakers.Keys | Sort-Object
