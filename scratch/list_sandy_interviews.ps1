$transcriptPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"
$lines = Get-Content $transcriptPath -Encoding utf8

$sandyInterviews = @()
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^Sandy:') {
        # Find who Sandy is addressing in the next few lines
        $context = ""
        for ($j = 1; $j -le 5; $j++) {
            if ($i + $j -lt $lines.Length) {
                $context += " | " + $lines[$i + $j].Trim()
            }
        }
        $sandyInterviews += "Line $($i+1): $($line.Trim()) -> Context: $context"
    }
}

Write-Host "--- Sandy Speak Occurrences ---"
foreach ($si in $sandyInterviews) {
    if ($si -like "*Hi*" -or $si -like "*hello*" -or $si -like "*pronounce*" -or $si -like "*fitment*") {
        Write-Host $si
    }
}
