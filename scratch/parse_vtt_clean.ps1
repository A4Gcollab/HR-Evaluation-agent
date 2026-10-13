$vttPath = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt"
$lines = Get-Content $vttPath -Encoding utf8

$speakerTurns = @{}
$speakerText = @{}
$speakerFirstLine = @{}
$speakerLastLine = @{}

$currentSpeaker = $null
$currentTime = ""

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i].Trim()
    if ($line -match '^\d{2}:\d{2}:\d{2}\.\d{3}\s*-->\s*\d{2}:\d{2}:\d{2}\.\d{3}') {
        $currentTime = $line
        continue
    }
    if ($line -match '^\d+$' -or $line -eq "WEBVTT" -or $line -eq "") {
        continue
    }

    if ($line -match '^([^:]+):\s*(.*)') {
        $speaker = $Matches[1].Trim()
        $text = $Matches[2].Trim()
        if (-not $speakerTurns.ContainsKey($speaker)) {
            $speakerTurns[$speaker] = 0
            $speakerText[$speaker] = [System.Collections.Generic.List[string]]::new()
            $speakerFirstLine[$speaker] = $i
        }
        $speakerTurns[$speaker]++
        $speakerLastLine[$speaker] = $i
        if ($text -ne "") {
            $speakerText[$speaker].Add($text)
        }
    }
}

Write-Host "Real Speakers in VTT (ordered by first appearance):"
$sorted = $speakerFirstLine.GetEnumerator() | Sort-Object Value
foreach ($s in $sorted) {
    $name = $s.Key
    $count = $speakerTurns[$name]
    $first = $speakerFirstLine[$name]
    $last = $speakerLastLine[$name]
    Write-Host "$name : Turns=$count, FirstLine=$first, LastLine=$last"
}
