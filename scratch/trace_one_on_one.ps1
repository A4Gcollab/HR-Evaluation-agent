$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$candidates = @("Vedant Deshpande", "Yimkumer Pongen", "Chandraveer Singh Solanki", "Talari Sanjay", "Arpit Kumar")

foreach ($cand in $candidates) {
    Write-Host "`n======================================================="
    Write-Host "TRACE FOR: $cand"
    Write-Host "======================================================="
    $inInterview = $false
    for ($i = 2000; $i -lt $lines.Length; $i++) {
        $l = $lines[$i].Trim()
        if ($l -match '^([^:]+):\s*(.*)') {
            $spk = $Matches[1].Trim()
            $txt = $Matches[2].Trim()
            if ($spk -eq $cand) {
                Write-Host "Line $($i+1) [$spk]: $txt"
            } elseif ($txt -match $cand -or ($txt -match ($cand.Split(" ")[0]))) {
                Write-Host "Line $($i+1) [$spk refers to $cand]: $txt"
            }
        }
    }
}
