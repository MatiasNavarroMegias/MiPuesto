#!/usr/bin/env pwsh
# Master Deployment Script - Everything Automated

param()

$ErrorActionPreference = 'Continue'

# Colors
$Green = "`e[32m"
$Red = "`e[31m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

$startTime = Get-Date

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host "$Magenta|$Reset     MiPuesto - MASTER DEPLOYMENT SCRIPT$Magenta     |$Reset"
    Write-Host "$Magenta|$Reset        Everything automated - Just confirm$Magenta   |$Reset"
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host ""
}

function Show-Menu {
    Write-Host "$Cyan=== WHAT DO YOU WANT? ===$Reset"
    Write-Host ""
    Write-Host "  $Blue 1$Reset Deploy to Production (Supabase + Render + Vercel)"
    Write-Host "  $Blue 2$Reset Setup Local Development"
    Write-Host "  $Blue 3$Reset Configure Environment Variables Only"
    Write-Host "  $Blue 4$Reset Test Deployment"
    Write-Host "  $Blue 5$Reset Exit"
    Write-Host ""
    $choice = Read-Host "Choose (1-5)"
    return $choice
}

function Deploy-Production {
    Write-Host ""
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host "$Magenta|$Reset          PRODUCTION DEPLOYMENT$Magenta              |$Reset"
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host ""
    
    Write-Host "This will:"
    Write-Host "  1. Configure environment variables"
    Write-Host "  2. Open browser to each platform"
    Write-Host "  3. You deploy at each platform"
    Write-Host "  4. Verify everything works"
    Write-Host ""
    
    $confirm = Read-Host "$Yellow Continue? (yes/no)$Reset"
    if ($confirm -ne "yes") {
        return
    }
    
    Write-Host "$Cyan Running setup-env.ps1...$Reset"
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$Red Setup failed$Reset"
        return
    }
    
    Write-Host ""
    Write-Host "$Cyan Running deploy-auto.ps1...$Reset"
    & powershell -ExecutionPolicy Bypass -File deploy-auto.ps1
}

function Setup-Local {
    Write-Host ""
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host "$Magenta|$Reset       LOCAL DEVELOPMENT SETUP$Magenta                |$Reset"
    Write-Host "$Magenta=========================================================$Reset"
    Write-Host ""
    
    Write-Host "$Cyan Running setup-env.ps1...$Reset"
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
    
    if ($LASTEXITCODE -ne 0) {
        return
    }
    
    Write-Host ""
    Write-Host "$Cyan Installing dependencies...$Reset"
    pnpm install
    
    Write-Host ""
    Write-Host "$Cyan Setting up database...$Reset"
    Set-Location database
    pnpm prisma migrate deploy
    pnpm prisma db seed
    Set-Location ..
    
    Write-Host ""
    Write-Host "$Cyan Building project...$Reset"
    pnpm build
    
    Write-Host ""
    Write-Host "$Green Setup complete!$Reset"
    Write-Host "Start dev:"
    Write-Host "  $Blue pnpm --filter @mipuesto/web dev$Reset (localhost:3000)"
    Write-Host "  $Blue pnpm --filter @mipuesto/api dev$Reset (localhost:3001)"
}

function Setup-EnvOnly {
    Write-Host ""
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
}

function Test-Deployment {
    Write-Host ""
    if (Test-Path "test-deployment.ps1") {
        & powershell -ExecutionPolicy Bypass -File test-deployment.ps1
    } else {
        Write-Host "$Red test-deployment.ps1 not found$Reset"
    }
}

function Show-Complete {
    $elapsed = (Get-Date) - $startTime
    Write-Host ""
    Write-Host "$Green Done in $([math]::Round($elapsed.TotalMinutes, 2)) minutes!$Reset"
    Write-Host ""
}

# Main
Show-Banner
Write-Host "$Yellow Welcome to MiPuesto automated deployment!$Reset"

while ($true) {
    $choice = Show-Menu
    
    switch ($choice) {
        "1" { Deploy-Production; Show-Complete }
        "2" { Setup-Local; Show-Complete }
        "3" { Setup-EnvOnly }
        "4" { Test-Deployment }
        "5" { Write-Host "$Green Goodbye!$Reset"; exit }
        default { Write-Host "$Red Invalid choice$Reset" }
    }
    
    $another = Read-Host "$Yellow Continue? (yes/no)$Reset"
    if ($another -ne "yes") {
        Show-Complete
        exit
    }
    Show-Banner
}
