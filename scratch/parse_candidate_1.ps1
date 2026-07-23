# parse_candidate_1.ps1
$vttFile = "Project Management Intern Interviews Transcript.vtt"
$lines = Get-Content $vttFile -Encoding utf8
for ($i = 3215; $i -lt 3260; $i++) {
    Write-Host "$i : $($lines[$i])"
}
