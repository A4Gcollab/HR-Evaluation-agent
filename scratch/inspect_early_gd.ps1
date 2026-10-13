$gdPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\scratch\gd_section.txt"
$lines = Get-Content $gdPath -Encoding utf8

$gdEliminatedEarly = @(
    "Mustafa Khurram", "agalya M", "Shaik Afrid", "Kashinath Biradar",
    "Shreyash Motgi", "Harsh Mandge", "Santosh", "SHARAD PUROHIT"
)

foreach ($c in $gdEliminatedEarly) {
    Write-Host "=============================="
    Write-Host "Candidate: $c"
    $dialogues = @()
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $l = $lines[$i].Trim()
        if ($l -match "^([^:]+):\s*(.*)") {
            $spk = $Matches[1].Trim()
            $txt = $Matches[2].Trim()
            if ($spk -eq $c) {
                Write-Host "  $txt"
            }
        }
    }
}
