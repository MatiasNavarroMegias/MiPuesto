#!/usr/bin/env pwsh
# Configure Environment Variables - Auto

param()

$ErrorActionPreference = 'Continue'

$Green = "`e[32m"
$Red = "`e[31m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Reset = "`e[0m"

Write-Host ""
Write-Host "$Magenta=========================================================$Reset"
Write-Host "$Magenta|$Reset   ENVIRONMENT VARIABLES CONFIGURATION$Magenta          |$Reset"
Write-Host "$Magenta=========================================================$Reset"
Write-Host ""

# Get database URL
Write-Host "Enter your Supabase DATABASE_URL:"
Write-Host "(Format: postgresql://user:pass@host:5432/database)"
$dbUrl = Read-Host

if (-not $dbUrl.StartsWith("postgresql://")) {
    Write-Host "$Red Invalid URL (must start with postgresql://)$Reset"
    exit 1
}

Write-Host ""
Write-Host "$Yellow Will you deploy to production now? (yes/no)$Reset"
$isProd = (Read-Host) -eq "yes"

# Generate JWT secret
$jwtSecret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object { [char]$_ })

$corsOrigin = "http://localhost:3000"
$apiUrl = "http://localhost:3001/api"

if ($isProd) {
    Write-Host ""
    Write-Host "Enter your Render backend URL (e.g., https://mipuesto-api.onrender.com):"
    $renderUrl = Read-Host
    if ($renderUrl) {
        $apiUrl = "$renderUrl/api"
        $corsOrigin = $renderUrl
    }
    
    Write-Host ""
    Write-Host "Enter your Vercel frontend URL (e.g., https://mipuesto.vercel.app):"
    $vercelUrl = Read-Host
    if ($vercelUrl) {
        $corsOrigin = $vercelUrl
    }
}

Write-Host ""
Write-Host "$Yellow Creating environment files...$Reset"
Write-Host ""

# Backend .env
@"
DATABASE_URL=$dbUrl
PORT=3001
CORS_ORIGIN=$corsOrigin
JWT_SECRET=$jwtSecret
NODE_ENV=$(if ($isProd) { 'production' } else { 'development' })
LOG_LEVEL=debug
"@ | Out-File -FilePath "services/api/.env" -Encoding UTF8 -NoNewline
Write-Host "$Green Created: services/api/.env$Reset"

# Frontend .env.local
@"
NEXT_PUBLIC_API_URL=$apiUrl
"@ | Out-File -FilePath "apps/web/.env.local" -Encoding UTF8 -NoNewline
Write-Host "$Green Created: apps/web/.env.local$Reset"

# Database .env
@"
DATABASE_URL=$dbUrl
"@ | Out-File -FilePath "database/.env" -Encoding UTF8 -NoNewline
Write-Host "$Green Created: database/.env$Reset"

Write-Host ""
Write-Host "$Green Configuration complete!$Reset"
Write-Host ""
Write-Host "Settings:"
Write-Host "  Database: Configured"
Write-Host "  API Port: 3001"
Write-Host "  CORS Origin: $corsOrigin"
Write-Host "  Mode: $(if ($isProd) { 'Production' } else { 'Development' })"
Write-Host ""
