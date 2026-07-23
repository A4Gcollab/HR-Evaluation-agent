$txtFile = "Project Management Interviews's transcript.txt"
$lines = Get-Content $txtFile -Encoding utf8
$lineNum = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match 'Kanak' -and ($line -match 'Sushma:' -or $line -match 'Suhani:')) {
        Write-Host "Kanak at $lineNum : $line"
    }
    if ($line -match 'Kushagra' -and ($line -match 'Sushma:' -or $line -match 'Suhani:')) {
        Write-Host "Kushagra at $lineNum : $line"
    }
}
