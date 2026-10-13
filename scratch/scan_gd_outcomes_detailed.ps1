$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

Write-Host "--- Scanning around Himanshu/Ayush elimination (lines 1180 to 1230) ---"
for ($i = 1180; $i -lt 1230; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}

Write-Host "`n--- Scanning around Sahil elimination (lines 1550 to 1615) ---"
for ($i = 1550; $i -lt 1615; $i++) {
    Write-Host "$($i+1): $($lines[$i])"
}
