$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$ranges = @(
    @{Name = "Bhumika K"; Start = 2940; End = 3780},
    @{Name = "Swetcha"; Start = 3780; End = 4548},
    @{Name = "Sowmiya K R"; Start = 4548; End = 5112}
)

foreach ($r in $ranges) {
    Write-Host "=== Candidate: $($r.Name) ==="
    $sandySpoke = $false
    $sushmaSpoke = $false
    for ($i = $r.Start; $i -lt $r.End; $i++) {
        $line = $lines[$i]
        if ($line -match '^Sandy:') { $sandySpoke = $true }
        if ($line -match '^Sushma:') { $sushmaSpoke = $true }
    }
    Write-Host "  Sushma (HR) Spoke: $sushmaSpoke"
    Write-Host "  Sandy (NF/OF) Spoke: $sandySpoke"
}
