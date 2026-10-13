$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

for ($i = 1620; $i -le 2100; $i++) {
    $l = $lines[$i].Trim()
    if ($l -ne "" -and -not ($l -match '^\d+$') -and -not ($l -match '^\d{2}:\d{2}:\d{2}')) {
        Write-Host "Line $($i+1): $l"
    }
}
