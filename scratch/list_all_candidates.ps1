$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8
$interviewers = @("Sushma", "Sanisha", "Swetcha", "Suhani_HR", "NITIN.T")
$candidates = @{}

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        if ($interviewers -notcontains $speaker) {
            if (-not $candidates.ContainsKey($speaker)) {
                $candidates[$speaker] = @{
                    First = $i + 1
                    Last = $i + 1
                    Turns = 0
                }
            }
            $candidates[$speaker].Turns++
            $candidates[$speaker].Last = $i + 1
        }
    }
}

$candidates.GetEnumerator() | Sort-Object { $_.Value.First } | ForEach-Object {
    [PSCustomObject]@{
        Name = $_.Key
        Turns = $_.Value.Turns
        FirstLine = $_.Value.First
        LastLine = $_.Value.Last
    }
} | Format-Table -AutoSize
