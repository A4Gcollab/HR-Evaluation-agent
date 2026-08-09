$txtPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Project Management Interviews 's transcript.txt"
$lines = Get-Content $txtPath -Encoding utf8

$outputFile = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\atif_transcript.txt"
$writer = New-Object System.IO.StreamWriter($outputFile, $false, [System.Text.Encoding]::UTF8)

$writer.WriteLine("==================================================")
$writer.WriteLine("ATIF TRANSCRIPT SEGMENTS")
$writer.WriteLine("==================================================")

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $isAtifSpeech = $line -match '^Atif:'
    $isInterviewerSpeech = $line -match '^(Sushma|Suhani|Suhani_HR):'
    
    if ($isAtifSpeech) {
        if ($i -gt 1 -and $lines[$i-1] -match '-->') {
            $writer.WriteLine($lines[$i-1].Trim())
        }
        $writer.WriteLine($line.Trim())
        $j = 1
        while ($i + $j -lt $lines.Length) {
            $next = $lines[$i+$j].Trim()
            if ($next -eq "") { $j++; continue }
            if ($next -match '^\d+:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]\_]+):') {
                break
            }
            $writer.WriteLine("   $next")
            $j++
        }
    } elseif ($isInterviewerSpeech) {
        # Check if this interviewer speech is close to Atif's speech
        $isNear = $false
        for ($k = -15; $k -le 15; $k++) {
            if ($i + $k -ge 0 -and $i + $k -lt $lines.Length) {
                if ($lines[$i+$k] -match '^Atif:') {
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
            $j = 1
            while ($i + $j -lt $lines.Length) {
                $next = $lines[$i+$j].Trim()
                if ($next -eq "") { $j++; continue }
                if ($next -match '^\d+:\d{2}:' -or $next -match '^([A-Za-z0-9\s\.\(\)\-\[\]\_]+):') {
                    break
                }
                $writer.WriteLine("   $next")
                $j++
            }
        }
    }
}

$writer.Close()
Write-Host "Atif transcript written to $outputFile"
