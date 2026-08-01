$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$outputFile = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\kaushik_transcript.txt"
$writer = New-Object System.IO.StreamWriter($outputFile, $false, [System.Text.Encoding]::UTF8)

$writer.WriteLine("==================================================")
$writer.WriteLine("KAUSHIK RANJAN TRANSCRIPT segments")
$writer.WriteLine("==================================================")

$inCandidateSection = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    
    # We want to print any line spoken by Kaushik, or any line spoken by Sushma/Swetcha near Kaushik's turns.
    # To keep it coherent, let's print the line if:
    # 1. It is spoken by kaushik ranjan
    # 2. It is spoken by Sushma or Swetcha and mentions kaushik (or occurs within 10 lines of Kaushik speaking)
    
    $isKaushikSpeech = $line -match '^kaushik ranjan:'
    $isInterviewerSpeech = $line -match '^(Sushma|Swetcha):'
    
    if ($isKaushikSpeech) {
        $inCandidateSection = $true
        # Print timestamp
        if ($i -gt 1 -and $lines[$i-1] -match '-->') {
            $writer.WriteLine($lines[$i-1].Trim())
        }
        $writer.WriteLine($line.Trim())
        # print subsequent lines
        $j = 1
        while ($i + $j -lt $lines.Length) {
            $next = $lines[$i+$j].Trim()
            if ($next -eq "") { $j++; continue }
            if ($next -match '^\d+:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
                break
            }
            $writer.WriteLine("   $next")
            $j++
        }
    } elseif ($isInterviewerSpeech) {
        # Check if this interviewer speech is close to a Kaushik speech (within 5 lines before or after)
        $isNear = $false
        for ($k = -15; $k -le 15; $k++) {
            if ($i + $k -ge 0 -and $i + $k -lt $lines.Length) {
                if ($lines[$i+$k] -match '^kaushik ranjan:') {
                    $isNear = $true
                    break
                }
            }
        }
        if ($isNear) {
            if ($i -gt 1 -and $lines[$i-1] -match '-->') {
                $writer.WriteLine($lines[$i-1].Trim())
            }
            $writer.WriteLine($line.Trim())
            # print subsequent lines
            $j = 1
            while ($i + $j -lt $lines.Length) {
                $next = $lines[$i+$j].Trim()
                if ($next -eq "") { $j++; continue }
                if ($next -match '^\d+:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]]+):') {
                    break
                }
                $writer.WriteLine("   $next")
                $j++
            }
        }
    }
}

$writer.Close()
Write-Host "Kaushik transcript written to $outputFile"
