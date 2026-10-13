$content = Get-Content -Path "gmt20260817-093726_recording.transcript.txt" -Encoding utf8
$speakers = @{}
foreach ($line in $content) {
    if ($line -match "^([^:]+):") {
        $name = $Matches[1].Trim()
        $speakers[$name] = $true
    }
}
$speakers.Keys | Sort-Object
