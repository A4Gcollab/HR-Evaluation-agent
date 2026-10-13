$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$transitions = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^(Sushma|Sanisha|Swetcha|Suhani_HR|NITIN\.T):\s*(.*)') {
        $interviewer = $Matches[1]
        $text = $Matches[2]
        
        # Check for keywords indicating round transitions, names called, shortlisting, etc.
        if ($text -match '(round|breakout|room|shortlist|congrat|eliminate|next round|HR round|fit|natural|org|GD|group discussion|conclude|interview)' -or
            $text -match '(Arpit|Chandraveer|Nubaid|Divyansh|Vedant|Yimkumer|Talari|Sanjay|Afrid|Rukhsar|Moupriyo|Mustafa)') {
            # Let's save interesting interviewer cues
            $transitions.Add("Line $($i+1) [$interviewer]: $text")
        }
    }
}

Write-Host "Total interesting interviewer cues: $($transitions.Count)"
# Let's output sample every few cues or write to a scratch file
$transitions | Out-File -FilePath "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\interviewer_timeline.txt" -Encoding utf8
Write-Host "Saved interviewer timeline to scratch/interviewer_timeline.txt"
