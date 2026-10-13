$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning for Himanshu and Ayush between 1200 and 1785 ---"
for ($i = 1200; $i -lt 1785; $i++) {
    $line = $lines[$i]
    if ($line -match '^(Sushma_HR|Himanshu|Ayush|Anjana|Shreya|Sahil|Swetcha):') {
        Write-Host "Line $($i+1): $line"
    }
}
