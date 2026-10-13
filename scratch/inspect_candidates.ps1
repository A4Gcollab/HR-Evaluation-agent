$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$interviewers = @("Sushma", "Sanisha", "Swetcha", "Suhani_HR", "NITIN.T")

# Map of candidate name -> details
$candidates = @{}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        $text = $Matches[2].Trim()
        if ($interviewers -notcontains $speaker) {
            if (-not $candidates.ContainsKey($speaker)) {
                $candidates[$speaker] = @{
                    FirstLine = $i + 1
                    LastLine = $i + 1
                    Turns = 0
                    SampleUtterances = [System.Collections.Generic.List[string]]::new()
                }
            }
            $candidates[$speaker].Turns++
            $candidates[$speaker].LastLine = $i + 1
            if ($candidates[$speaker].SampleUtterances.Count -lt 5) {
                $candidates[$speaker].SampleUtterances.Add("Line $($i+1): $text")
            }
        }
    }
}

Write-Host "Total non-interviewer speakers found: $($candidates.Count)`n"

foreach ($name in ($candidates.Keys | Sort-Object)) {
    $info = $candidates[$name]
    Write-Host "=============================="
    Write-Host "Candidate: $name (Turns: $($info.Turns), Lines: $($info.FirstLine) - $($info.LastLine))"
    foreach ($sample in $info.SampleUtterances) {
        Write-Host "  $sample"
    }
}
