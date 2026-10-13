$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning for Anjana and Shreya ---"
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Anjana Kumari|Shreya Kumari|Sushma_HR):') {
        # Print only if it mentions Anjana or Shreya or is spoken by them
        if ($line -match '(Anjana|Shreya)' -or $line -match '^(Anjana Kumari|Shreya Kumari):') {
            Write-Host "Line $($i+1): $line"
        }
    }
}
