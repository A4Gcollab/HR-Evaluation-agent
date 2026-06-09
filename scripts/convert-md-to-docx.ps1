# convert-md-to-docx.ps1
# Converts Markdown evaluation reports to formatted .docx files using Microsoft Word COM interface.
param(
    [string]$InputPath,
    [string]$OutputPath
)

if (-not $InputPath -or -not $OutputPath) {
    Write-Error "Usage: .\convert-md-to-docx.ps1 -InputPath <input.md> -OutputPath <output.docx>"
    exit 1
}

$absoluteInputPath = Resolve-Path $InputPath
$absoluteOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

Write-Host "Converting $absoluteInputPath to $absoluteOutputPath..."

# Start Microsoft Word
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
} catch {
    Write-Error "Failed to start Microsoft Word. Please ensure Word is installed on your system."
    exit 1
}

# Create a new document
$doc = $word.Documents.Add()
$selection = $word.Selection

# Configure page margins (2 cm top/bottom, 2.5 cm left/right)
$section = $doc.Sections.Item(1)
$section.PageSetup.TopMargin = $word.CentimetersToPoints(2)
$section.PageSetup.BottomMargin = $word.CentimetersToPoints(2)
$section.PageSetup.LeftMargin = $word.CentimetersToPoints(2.5)
$section.PageSetup.RightMargin = $word.CentimetersToPoints(2.5)

# Set default font
$selection.Font.Name = "Calibri"
$selection.Font.Size = 11
$selection.ParagraphFormat.SpaceAfter = 6

$lines = Get-Content -Path $absoluteInputPath -Encoding utf8
$i = 0
$lineCount = $lines.Count

# Shading helper
function Set-CellShading($cell, $hexColor) {
    $cell.Shading.BackgroundPatternColor = [int]("0x" + $hexColor)
}

while ($i -lt $lineCount) {
    $line = $lines[$i].Trim()

    # Skip empty lines
    if ($line -eq "") {
        $i++
        continue
    }

    # Handle Horizontal Rule
    if ($line -eq "---") {
        $paragraph = $doc.Paragraphs.Add()
        $paragraph.Range.Text = "_________________________________________________________________________________"
        $paragraph.Range.Font.Color = 8421504 # Gray
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }

    # Handle Headings
    if ($line.StartsWith("# ")) {
        $headingText = $line.Substring(2).Replace("**", "").Replace("__", "")
        $paragraph = $doc.Paragraphs.Add()
        $paragraph.Range.Text = $headingText
        $paragraph.Range.Font.Name = "Calibri"
        $paragraph.Range.Font.Size = 18
        $paragraph.Range.Font.Bold = $true
        $paragraph.Range.Font.Color = 5718062 # RGB 0x2E, 0x40, 0x57 (HEX 2E4057 -> BGR 57402E = 5718062 in decimal BGR for Word COM)
        # Word COM uses BGR decimal color values: 2E4057 in RGB is 57402E in HEX BGR -> 5718062 decimal
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }
    if ($line.StartsWith("## ")) {
        $headingText = $line.Substring(3).Replace("**", "").Replace("__", "")
        $paragraph = $doc.Paragraphs.Add()
        $paragraph.Range.Text = $headingText
        $paragraph.Range.Font.Name = "Calibri"
        $paragraph.Range.Font.Size = 14
        $paragraph.Range.Font.Bold = $true
        $paragraph.Range.Font.Color = 5718062
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }
    if ($line.StartsWith("### ")) {
        $headingText = $line.Substring(4).Replace("**", "").Replace("__", "")
        $paragraph = $doc.Paragraphs.Add()
        $paragraph.Range.Text = $headingText
        $paragraph.Range.Font.Name = "Calibri"
        $paragraph.Range.Font.Size = 12
        $paragraph.Range.Font.Bold = $true
        $paragraph.Range.Font.Color = 5718062
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }

    # Handle Bullet List Items
    if ($line.StartsWith("- ") -or $line.StartsWith("* ")) {
        $bulletText = $line.Substring(2)
        
        $paragraph = $doc.Paragraphs.Add()
        
        # Parse bold parts in bullets
        $cleanText = $bulletText.Replace("**", "").Replace("__", "")
        $paragraph.Range.Text = $cleanText
        $paragraph.Style = "List Bullet"
        $paragraph.Range.Font.Name = "Calibri"
        $paragraph.Range.Font.Size = 11
        $paragraph.Range.Font.Bold = $false
        
        # Apply bold to text before the first colon (like "Key Risk: ...")
        if ($bulletText.Contains("**") -and $bulletText.Contains(":")) {
            $parts = $bulletText.Split(":")
            if ($parts[0].StartsWith("**") -and $parts[0].EndsWith("**")) {
                $boldTextLength = $parts[0].Length - 4
                $boldRange = $doc.Range($paragraph.Range.Start, $paragraph.Range.Start + $boldTextLength)
                $boldRange.Font.Bold = $true
            }
        }
        
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }

    # Handle Blockquotes (like Warning Notes)
    if ($line.StartsWith("> ")) {
        $quoteText = $line.Substring(2).Replace("**", "").Replace("__", "")
        $paragraph = $doc.Paragraphs.Add()
        $paragraph.Range.Text = $quoteText
        $paragraph.Range.Font.Name = "Calibri"
        $paragraph.Range.Font.Size = 9.5
        $paragraph.Range.Font.Italic = $true
        $paragraph.Range.Font.Color = 8421504 # Gray
        $paragraph.Range.InsertParagraphAfter()
        $i++
        continue
    }

    # Handle Tables
    if ($line.StartsWith("|")) {
        # Collect table lines
        $tableLines = @()
        while ($i -lt $lineCount -and $lines[$i].Trim().StartsWith("|")) {
            $tableLines += $lines[$i].Trim()
            $i++
        }

        # Parse table cells
        $rows = @()
        foreach ($tl in $tableLines) {
            # Skip divider line (|---|---|)
            if ($tl -match '^\|[\s\-\|]+$') {
                continue
            }
            $cells = $tl.Split('|') | ForEach-Object { $_.Trim() }
            # Remove first and last empty elements from split border
            if ($cells.Count -gt 1) {
                $rowCells = $cells[1..($cells.Count - 2)]
                $rows += ,$rowCells
            }
        }

        if ($rows.Count -gt 0) {
            $rowCount = $rows.Count
            $colCount = $rows[0].Count

            # Add table at end of document
            $range = $doc.Bookmarks.Item("\endofdoc").Range
            $table = $doc.Tables.Add($range, $rowCount, $colCount)
            $table.Borders.Enable = $true
            
            # Styling Table grid
            for ($r = 0; $r -lt $rowCount; $r++) {
                for ($c = 0; $c -lt $colCount; $c++) {
                    $cell = $table.Cell($r + 1, $c + 1)
                    $rawVal = $rows[$r][$c]
                    $cleanVal = $rawVal.Replace("**", "").Replace("__", "")
                    $cell.Range.Text = $cleanVal
                    $cell.Range.Font.Name = "Calibri"
                    $cell.Range.Font.Size = 9.5

                    # Formatting headers (row 0)
                    if ($r -eq 0) {
                        $cell.Range.Font.Bold = $true
                        $cell.Range.Font.Color = 16777215 # White
                        Set-CellShading -cell $cell -hexColor "2E4057" # Dark blue-gray
                        $cell.Range.ParagraphFormat.Alignment = 1 # Center
                    } else {
                        # Zebra striping for odd rows
                        if ($r % 2 -eq 1) {
                            Set-CellShading -cell $cell -hexColor "F0F4F8"
                        }
                        # Make first column bold for details tables (like Details tables)
                        if ($c -eq 0 -and $rawVal.StartsWith("**") -and $rawVal.EndsWith("**")) {
                            $cell.Range.Font.Bold = $true
                        }
                    }
                }
            }
            
            # Add spacing paragraph after table
            $paragraph = $doc.Paragraphs.Add()
            $paragraph.Range.InsertParagraphAfter()
        }
        continue
    }

    # Handle Normal Paragraphs
    $cleanText = $line.Replace("**", "").Replace("__", "")
    $paragraph = $doc.Paragraphs.Add()
    $paragraph.Range.Text = $cleanText
    $paragraph.Range.Font.Name = "Calibri"
    $paragraph.Range.Font.Size = 11
    $paragraph.Range.Font.Bold = $false
    $paragraph.Range.Font.Italic = $false
    $paragraph.Range.Font.Color = 0 # Black
    
    # If the paragraph is italicized in MD
    if ($line.StartsWith("*") -and $line.EndsWith("*")) {
        $paragraph.Range.Font.Italic = $true
    }
    
    $paragraph.Range.InsertParagraphAfter()
    $i++
}

# Save and Close
$doc.SaveAs([ref]$absoluteOutputPath)
$doc.Close()
$word.Quit()

Write-Host "Success! Document saved to $absoluteOutputPath"
