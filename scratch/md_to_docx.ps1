$ErrorActionPreference = "Stop"

$input_file = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\data\evaluation-reports\batch-2026-09-11-rab.md"
$output_html = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\data\evaluation-reports\temp.html"
$output_docx = "c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\data\evaluation-reports\batch-2026-09-11-rab.docx"

$lines = Get-Content $input_file -Encoding UTF8
$html = New-Object System.Collections.Generic.List[string]
$html.Add("<html><head><style>table, th, td { border: 1px solid black; border-collapse: collapse; padding: 5px; } th { background-color: #f2f2f2; font-weight: bold; }</style></head><body style='font-family: Calibri, sans-serif;'>")

$inTable = $false
$inList = $false
$isFirstRow = $false

foreach ($line in $lines) {
    # Basic inline formatting
    $line = $line -replace '\*\*(.*?)\*\*', '<b>$1</b>'
    $line = $line -replace '\*(.*?)\*', '<i>$1</i>'
    $line = $line -replace '`(.*?)`', '<code>$1</code>'

    if ($line -match '^\|.*\|$') {
        if (-not $inTable) {
            $inTable = $true
            $isFirstRow = $true
            $html.Add("<table>")
        }
        
        if ($line -match '^\|[- |]+\|$') {
            continue
        }

        $cells = $line.Trim('|').Split('|')
        $html.Add("<tr>")
        foreach ($cell in $cells) {
            $cellText = $cell.Trim()
            if ($isFirstRow) {
                $html.Add("<th>$cellText</th>")
            } else {
                $html.Add("<td>$cellText</td>")
            }
        }
        $html.Add("</tr>")
        $isFirstRow = $false
    } else {
        if ($inTable) {
            $inTable = $false
            $html.Add("</table><br>")
        }

        if ($line -match '^- (.*)') {
            if (-not $inList) {
                $inList = $true
                $html.Add("<ul>")
            }
            $html.Add("<li>$($matches[1])</li>")
        } else {
            if ($inList) {
                $inList = $false
                $html.Add("</ul>")
            }

            if ($line -match '^### (.*)') {
                $html.Add("<h3>$($matches[1])</h3>")
            } elseif ($line -match '^## (.*)') {
                $html.Add("<h2>$($matches[1])</h2>")
            } elseif ($line -match '^# (.*)') {
                $html.Add("<h1>$($matches[1])</h1>")
            } elseif ($line -match '^---$') {
                $html.Add("<hr>")
            } elseif ([string]::IsNullOrWhiteSpace($line)) {
                $html.Add("<br>")
            } else {
                $html.Add("<p>$line</p>")
            }
        }
    }
}

if ($inTable) { $html.Add("</table>") }
if ($inList) { $html.Add("</ul>") }

$html.Add("</body></html>")

[IO.File]::WriteAllLines($output_html, $html, [Text.Encoding]::UTF8)

Write-Host "HTML created, starting Word..."

$word = New-Object -ComObject Word.Application
$word.Visible = $false

try {
    $doc = $word.Documents.Open($output_html)
    # 16 is wdFormatDocumentDefault
    $doc.SaveAs2($output_docx, 16)
    $doc.Close()
    Write-Host "DOCX created successfully at $output_docx"
} finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    Remove-Item $output_html -ErrorAction SilentlyContinue
}
