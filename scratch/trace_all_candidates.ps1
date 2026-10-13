$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidates = @(
    "Mustafa Khurram", "Arpit Kumar", "agalya M", "Shaik Afrid", "Kashinath Biradar",
    "NUBAID UDDIN", "Divyansh Verma", "Shreyash Motgi", "Harsh Mandge", "Santosh",
    "Vedant Deshpande", "SHARAD PUROHIT", "rukhsarkhan", "ishrattaj Dharwad",
    "Maniraj Singh Yadav", "Moupriyo Jana", "Chandraveer Singh Solanki", "Rookhmani Kandu",
    "Kuraparthi Ajay", "Yimkumer Pongen", "Aman", "Talari Sanjay"
)

$summary = @()

foreach ($cand in $candidates) {
    $firstLine = -1
    $lastLine = -1
    $totalTurns = 0
    $gdSpoke = $false
    $postGdSpoke = $false
    $oneOnOneSpoke = $false

    for ($i = 0; $i -lt $lines.Length; $i++) {
        $l = $lines[$i].Trim()
        if ($l -match '^([^:]+):\s*(.*)') {
            $spk = $Matches[1].Trim()
            if ($spk -eq $cand) {
                if ($firstLine -eq -1) { $firstLine = $i + 1 }
                $lastLine = $i + 1
                $totalTurns++

                if ($i -lt 1650) {
                    $gdSpoke = $true
                } elseif ($i -lt 2050) {
                    $postGdSpoke = $true
                } else {
                    $oneOnOneSpoke = $true
                }
            }
        }
    }

    $summary += [PSCustomObject]@{
        Candidate = $cand
        Turns = $totalTurns
        FirstLine = $firstLine
        LastLine = $lastLine
        GD = $gdSpoke
        PostGD = $postGdSpoke
        OneOnOne = $oneOnOneSpoke
    }
}

$summary | Format-Table -AutoSize
