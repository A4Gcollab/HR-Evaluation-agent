try {
    $word = New-Object -ComObject Word.Application
    Write-Host "Success: Word COM is available! Version: $($word.Version)"
    $word.Quit()
} catch {
    Write-Error "Failed to start Word COM: $_"
}
