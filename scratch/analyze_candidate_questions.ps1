$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

$candidates = @(
    @{Name = "Ruchira"; StartLine = 3250; EndLine = 3940},
    @{Name = "Katyayani"; StartLine = 4350; EndLine = 4660},
    @{Name = "Anushka"; StartLine = 5000; EndLine = 5180},
    @{Name = "Aastha"; StartLine = 6000; EndLine = 6213}
)

foreach ($c in $candidates) {
    Write-Host "`n=================================================="
    Write-Host "Candidate: $($c.Name) (Lines $($c.StartLine) - $($c.EndLine))"
    Write-Host "=================================================="
    for ($i = $c.StartLine - 1; $i -lt $c.EndLine; $i++) {
        if ($i -lt $lines.Length) {
            $line = $lines[$i]
            if ($line -match '^Sandy:') {
                Write-Host "$($i+1): $line"
                # Print the next non-empty line or two to see the question
                for ($j = 1; $j -le 4; $j++) {
                    if ($i + $j -lt $lines.Length) {
                        $next = $lines[$i + $j].Trim()
                        if ($next -ne "" -and $next -notmatch '^\d{2}:\d{2}:') {
                            Write-Host "      $next"
                        }
                    }
                }
            }
        }
    }
}
