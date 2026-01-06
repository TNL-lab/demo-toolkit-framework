# ==============================
# Script to delete all GitHub Actions runs
# Run in PowerShell, repo must have gh CLI logged in
# ==============================

# Check if gh CLI is logged in
try {
    gh auth status | Out-Null
} catch {
    Write-Host "GitHub CLI not logged in. Run: gh auth login" -ForegroundColor Red
    break
}

Write-Host "Starting to delete all workflow runs..." -ForegroundColor Cyan

do {
    # Get up to 1000 most recent workflow runs
    $runs = gh run list --limit 1000 --json databaseId | ConvertFrom-Json

    if ($runs.Count -eq 0) {
        Write-Host "No workflow runs left to delete." -ForegroundColor Green
        break
    }

    foreach ($run in $runs) {
        try {
            # Auto-confirm deletion
            echo y | gh run delete $run.databaseId
            Write-Host "Deleted run ID: $($run.databaseId)" -ForegroundColor Yellow
        } catch {
            Write-Host "Error deleting run ID: $($run.databaseId)" -ForegroundColor Red
        }
    }

    # Small delay to avoid rate limit
    Start-Sleep -Milliseconds 500

} while ($runs.Count -gt 0)

Write-Host "Finished deleting all workflow runs!" -ForegroundColor Green
