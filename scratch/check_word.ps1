try {
    $word = New-Object -ComObject Word.Application
    Write-Host "Word is available"
    $word.Quit()
} catch {
    Write-Host "Word is NOT available: $_"
}
