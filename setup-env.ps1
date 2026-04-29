#!/usr/bin/env pwsh

# 🔧 Configure Environment Variables - FULLY AUTOMATED
# This script sets up ALL environment variables automatically

param()

$ErrorActionPreference = "Continue"

$Green = "`e[32m"
$Red = "`e[31m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}       🔧 Environment Variables Auto-Configuration${Magenta}  ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
}

function Create-EnvFile {
    param([string]$filePath, [hashtable]$variables)
    
    $content = ""
    foreach ($key in $variables.Keys) {
        $content += "$key=$($variables[$key])`n"
    }
    
    $content | Out-File -FilePath $filePath -Encoding UTF8 -NoNewline
    Write-Host "${Green}✅ Created: $filePath${Reset}"
}

function Get-RandomSecret {
    param([int]$length = 32)
    $chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    $secret = ""
    for ($i = 0; $i -lt $length; $i++) {
        $secret += $chars[(Get-Random -Maximum $chars.Length)]
    }
    return $secret
}

Show-Banner

Write-Host "${Yellow}This will configure all environment variables automatically.${Reset}"
Write-Host ""
Write-Host "Required inputs:"
Write-Host "  1. Supabase DATABASE_URL"
Write-Host "  2. Render/Vercel URLs"
Write-Host ""

$dbUrl = Read-Host "${Yellow}1. Enter your Supabase DATABASE_URL${Reset}"

if (-not $dbUrl.StartsWith("postgresql://")) {
    Write-Host "${Red}❌ Invalid database URL${Reset}"
    exit
}

Write-Host ""
Write-Host "${Yellow}2. Will you deploy to production now? (yes/no)${Reset}"
$deployNow = Read-Host
$isProduction = ($deployNow -eq "yes")

# Generate secrets
$jwtSecret = Get-RandomSecret 32
Write-Host ""
Write-Host "${Green}Generated JWT_SECRET: ${Blue}$jwtSecret${Reset}"

# Ask for URLs if deploying
$corsOrigin = "http://localhost:3000"
$apiUrl = "http://localhost:3001"

if ($isProduction) {
    Write-Host ""
    Write-Host "${Yellow}3. Enter your Render backend URL${Reset}"
    Write-Host "   (e.g., https://mipuesto-api.onrender.com)${Reset}"
    $renderUrl = Read-Host
    if ($renderUrl) {
        $apiUrl = $renderUrl
    }
    
    Write-Host ""
    Write-Host "${Yellow}4. Enter your Vercel frontend URL${Reset}"
    Write-Host "   (e.g., https://mipuesto.vercel.app)${Reset}"
    $vercelUrl = Read-Host
    if ($vercelUrl) {
        $corsOrigin = $vercelUrl
    }
}

Write-Host ""
Write-Host "${Cyan}Creating environment files...${Reset}"
Write-Host ""

# Backend .env (services/api/.env)
$backendEnv = @{
    "DATABASE_URL" = $dbUrl
    "PORT" = "3001"
    "CORS_ORIGIN" = $corsOrigin
    "JWT_SECRET" = $jwtSecret
    "NODE_ENV" = if ($isProduction) { "production" } else { "development" }
    "LOG_LEVEL" = "debug"
}

Create-EnvFile "services/api/.env" $backendEnv

# Frontend .env.local (apps/web/.env.local)
$frontendEnv = @{
    "NEXT_PUBLIC_API_URL" = "$apiUrl/api"
}

Create-EnvFile "apps/web/.env.local" $frontendEnv

# Database .env (database/.env)
$dbEnv = @{
    "DATABASE_URL" = $dbUrl
}

Create-EnvFile "database/.env" $dbEnv

Write-Host ""
Write-Host "${Cyan}Environment files created!${Reset}"
Write-Host ""

# Show summary
Write-Host "${Green}✅ Configuration Complete${Reset}"
Write-Host ""
Write-Host "Files configured:"
Write-Host "  ✓ services/api/.env"
Write-Host "  ✓ apps/web/.env.local"
Write-Host "  ✓ database/.env"
Write-Host ""
Write-Host "Settings:"
Write-Host "  • Database: ${Blue}Configured${Reset}"
Write-Host "  • API Port: ${Blue}3001${Reset}"
Write-Host "  • CORS: ${Blue}$corsOrigin${Reset}"
Write-Host "  • JWT Secret: ${Blue}Generated${Reset}"
Write-Host "  • Mode: ${Blue}$(if ($isProduction) { 'Production' } else { 'Development' })${Reset}"
Write-Host ""

if (-not $isProduction) {
    Write-Host "${Yellow}Next step:${Reset}"
    Write-Host "  powershell -ExecutionPolicy Bypass -File dev.ps1"
    Write-Host ""
} else {
    Write-Host "${Green}✅ Ready to deploy!${Reset}"
    Write-Host ""
}

Write-Host "${Magenta}═══════════════════════════════════════════════════════${Reset}"
