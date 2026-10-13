$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260811-TECH- Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

# Extract Nishad
$nishadLines = $lines[1800..2405]
$nishadLines | Out-File -FilePath "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\nishad_transcript.txt" -Encoding utf8
Write-Host "Extracted Nishad's transcript to scratch\nishad_transcript.txt"

# Extract Ariti
$aritiLines = $lines[2406..3220]
$aritiLines | Out-File -FilePath "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\ariti_transcript.txt" -Encoding utf8
Write-Host "Extracted Ariti's transcript to scratch\ariti_transcript.txt"

# Extract Jahnavi
$jahnaviLines = $lines[3221..($lines.Length-1)]
$jahnaviLines | Out-File -FilePath "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\jahnavi_transcript.txt" -Encoding utf8
Write-Host "Extracted Jahnavi's transcript to scratch\jahnavi_transcript.txt"
