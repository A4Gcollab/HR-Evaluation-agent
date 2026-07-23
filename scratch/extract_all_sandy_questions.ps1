$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$ranges = @(
    @{Name = "Bhumika K"; Start = 2940; End = 3780},
    @{Name = "Swetcha"; Start = 3780; End = 4548},
    @{Name = "Sowmiya K R"; Start = 4548; End = 5112},
    @{Name = "yashna"; Start = 5112; End = 5536},
    @{Name = "Eshita Singh"; Start = 5536; End = 5882}
)

foreach ($r in $ranges) {
    Write-Host "`n=== Sandy Questions for $($r.Name) ==="
    for ($i = $r.Start; $i -lt $r.End; $i++) {
        $line = $lines[$i]
        if ($line -match '^Sandy:') {
            # Check if this line looks like a question or transition
            $question = $line.Trim()
            # print it and some following lines if Sandy continues speaking
            $j = 1
            while ($i + $j -lt $r.End -and $lines[$i+$j].Trim() -match '^Sandy:') {
                $question += " " + $lines[$i+$j].Trim()
                $i++
            }
            Write-Host "  Line $($i+1): $question"
        }
    }
}
