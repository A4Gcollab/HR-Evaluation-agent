$gdPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\gd_section.txt"
$lines = Get-Content $gdPath -Encoding utf8

$gdEliminated = @(
    "Mustafa Khurram", "agalya M", "Shaik Afrid", "Kashinath Biradar",
    "Shreyash Motgi", "Harsh Mandge", "Santosh", "SHARAD PUROHIT",
    "rukhsarkhan", "ishrattaj Dharwad", "Maniraj Singh Yadav", "Moupriyo Jana",
    "Rookhmani Kandu", "Kuraparthi Ajay", "Aman"
)

foreach ($c in $gdEliminated) {
    Write-Host "=============================="
    Write-Host "Candidate: $c"
    $dialogues = @()
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $l = $lines[$i].Trim()
        if ($l -match "^([^:]+):\s*(.*)") {
            $spk = $Matches[1].Trim()
            $txt = $Matches[2].Trim()
            if ($spk -eq $c) {
                $dialogues += "Line $($i+1): $txt"
            }
        }
    }
    Write-Host "Total turns: $($dialogues.Count)"
    foreach ($d in $dialogues) {
        Write-Host "  $d"
    }
}
