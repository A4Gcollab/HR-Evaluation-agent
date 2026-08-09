$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

# Sachindra Natural Fit starts at 2173, ends near 2424
Write-Host "=== Sachindra Natural Fit Round (Lines 2173 - 2424) ==="
for ($i = 2172; $i -lt 2424; $i++) {
    if ($i -lt $lines.Length) {
        Write-Host $lines[$i]
    }
}

# Sachindra Org Fit starts at 2425, ends near 2724
Write-Host "`n=== Sachindra Org Fit Round (Lines 2425 - 2724) ==="
for ($i = 2424; $i -lt 2724; $i++) {
    if ($i -lt $lines.Length) {
        Write-Host $lines[$i]
    }
}
