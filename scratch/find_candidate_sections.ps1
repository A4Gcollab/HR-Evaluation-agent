$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

# Let's print out lines around the starts of different sections to see candidate transitions
$linesToPrint = @(
    @{Title = "GD End / HR Round Start"; Start = 2700; End = 2850},
    @{Title = "Sandy Interview 1 Start"; Start = 3250; End = 3300},
    @{Title = "Sushma Interview 2 Start"; Start = 4340; End = 4385},
    @{Title = "Sandy Interview 3 Start"; Start = 4985; End = 5025},
    @{Title = "Sandy Interview 4 Start"; Start = 5980; End = 6030}
)

foreach ($item in $linesToPrint) {
    Write-Host "`n=== $($item.Title) (Lines $($item.Start) - $($item.End)) ==="
    for ($i = $item.Start - 1; $i -lt $item.End; $i++) {
        if ($i -lt $lines.Length) {
            Write-Host "$($i+1): $($lines[$i])"
        }
    }
}
