<#
.SYNOPSIS
  Keepawake for Supabase.

.NOTES
  Usage:
    .\awaken.ps1
#>

$ErrorActionPreference = "Stop"

# Config 
$SupabaseUrl = if ($env:SUPABASE_URL) { $env:SUPABASE_URL } else {
  Write-Error "No SUPABASE URL configured"
  exit 1
}
$SupabaseKey = if ($env:SUPABASE_KEY) { $env:SUPABASE_KEY } else {
  Write-Error "No SUPABASE KEY configured"
  exit 1
}

Write-Host "Waking Supabase"

$headers = @{
    "apikey"        = $SupabaseKey
    "Authorization" = "Bearer $SupabaseKey"
    "Content-Type"  = "application/json"
    "Prefer"        = "return=representation"
}

$timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$body = @{ note = "keepalive $timestamp" } | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$SupabaseUrl/rest/v1/test_awaker" -Method Post -Headers $headers -Body $body
    Write-Host "Supabase OK -> $($response | ConvertTo-Json -Compress)"
}
catch {
    Write-Error "Supabase request failed: $($_.Exception.Message)"
    exit 1
}

Write-Host ""
Write-Host "Done."
