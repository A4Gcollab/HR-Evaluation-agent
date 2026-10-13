$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

# Helper to extract lines between start and end
function Extract-Range($startLine, $endLine, $outFile) {
    $sb = [System.Text.StringBuilder]::new()
    for ($i = $startLine; $i -le $endLine; $i++) {
        $l = $lines[$i].Trim()
        if ($l -ne "" -and -not ($l -match '^\d+$') -and -not ($l -match '^\d{2}:\d{2}:\d{2}')) {
            $sb.AppendLine($l) | Out-Null
        }
    }
    [System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
    Write-Host "Saved $outFile (Lines $startLine - $endLine, Characters: $($sb.Length))"
}

# 1. Vedant 1-on-1 (around 2090 to 2420)
Extract-Range 2080 2420 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\vedant_1on1.txt"

# 2. Yimkumer 1-on-1 (around 2421 to 2840)
Extract-Range 2421 2845 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\yimkumer_1on1.txt"

# 3. Chandraveer 1-on-1 (around 2846 to 3815)
Extract-Range 2846 3815 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\chandraveer_1on1.txt"

# 4. HR Discussion between Chandraveer and Sanjay (3816 to 3960)
Extract-Range 3816 3965 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\hr_discussion_1.txt"

# 5. Talari Sanjay 1-on-1 (3966 to 4600)
Extract-Range 3966 4600 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\sanjay_1on1.txt"

# 6. Arpit Kumar 1-on-1 (4601 to 5000)
Extract-Range 4601 5000 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\arpit_1on1.txt"

# 7. Final HR debrief (5001 to 5238)
Extract-Range 5001 5237 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\final_hr_debrief.txt"

# 8. GD section (0 to 1660)
Extract-Range 0 1660 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\gd_section.txt"

# 9. Post-GD group discussion (1661 to 2080)
Extract-Range 1661 2080 "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\post_gd_motivation.txt"
