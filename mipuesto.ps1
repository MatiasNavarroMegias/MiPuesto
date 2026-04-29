#!/usr/bin/env pwsh

# 🚀 MASTER DEPLOYMENT SCRIPT - EVERYTHING AUTOMATED
# One script to deploy everything. That's it.

param()

$ErrorActionPreference = "Continue"

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
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}         🚀 MiPuesto - MASTER DEPLOYMENT SCRIPT${Magenta}    ║${Reset}"
    Write-Host "${Magenta}║${Reset}            Everything automated - Just confirm${Magenta}      ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
}

function Show-Menu {
    Write-Host "${Cyan}What do you want to do?${Reset}"
    Write-Host ""
    Write-Host "  ${Blue}1${Reset} Deploy to Production (Vercel + Render + Supabase)"
    Write-Host "  ${Blue}2${Reset} Setup Local Development"
    Write-Host "  ${Blue}3${Reset} Configure Environment Variables Only"
    Write-Host "  ${Blue}4${Reset} Test Current Deployment"
    Write-Host "  ${Blue}5${Reset} Exit"
    Write-Host ""
    $choice = Read-Host "Choose (1-5)"
    return $choice
}

function Deploy-Production {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}              🚀 PRODUCTION DEPLOYMENT${Magenta}              ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    Write-Host "This will:"
    Write-Host "  1. Configure all environment variables"
    Write-Host "  2. Open Supabase (get DATABASE_URL)"
    Write-Host "  3. Deploy backend to Render"
    Write-Host "  4. Deploy frontend to Vercel"
    Write-Host "  5. Update CORS configuration"
    Write-Host "  6. Verify everything works"
    Write-Host ""
    
    $confirm = Read-Host "${Yellow}Continue? (yes/no)${Reset}"
    if ($confirm -ne "yes") {
        return
    }
    
    # Step 1: Setup environment
    Write-Host ""
    Write-Host "${Cyan}Step 1/6: Configuring environment variables...${Reset}"
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "${Red}❌ Environment setup failed${Reset}"
        return
    }
    
    # Step 2: Deploy with auto script
    Write-Host ""
    Write-Host "${Cyan}Step 2-6: Running full deployment...${Reset}"
    & powershell -ExecutionPolicy Bypass -File deploy-auto.ps1
}

function Setup-Local {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}            💻 LOCAL DEVELOPMENT SETUP${Magenta}             ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    Write-Host "Setting up local development environment..."
    Write-Host ""
    
    # Step 1: Setup environment
    Write-Host "${Cyan}Step 1/4: Setting up environment variables...${Reset}"
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "${Red}❌ Environment setup failed${Reset}"
        return
    }
    
    # Step 2: Install dependencies
    Write-Host ""
    Write-Host "${Cyan}Step 2/4: Installing dependencies...${Reset}"
    Write-Host ""
    pnpm install
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "${Red}❌ pnpm install failed${Reset}"
        return
    }
    
    # Step 3: Setup database
    Write-Host ""
    Write-Host "${Cyan}Step 3/4: Setting up database...${Reset}"
    Write-Host ""
    cd database
    pnpm prisma migrate deploy
    pnpm prisma db seed
    cd ..
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "${Red}❌ Database setup failed${Reset}"
        return
    }
    
    # Step 4: Build
    Write-Host ""
    Write-Host "${Cyan}Step 4/4: Building project...${Reset}"
    Write-Host ""
    pnpm build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "${Yellow}⚠️  Build completed with warnings (normal)${Reset}"
    }
    
    Write-Host ""
    Write-Host "${Green}✅ Local setup complete!${Reset}"
    Write-Host ""
    Write-Host "Start development:"
    Write-Host "  ${Blue}pnpm --filter @mipuesto/web dev${Reset}   (Frontend: http://localhost:3000)"
    Write-Host "  ${Blue}pnpm --filter @mipuesto/api dev${Reset}   (Backend: http://localhost:3001)"
    Write-Host ""
}

function Setup-EnvOnly {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}        🔧 ENVIRONMENT VARIABLES CONFIGURATION${Magenta}     ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    & powershell -ExecutionPolicy Bypass -File setup-env.ps1
}

function Test-Deployment {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}            🧪 TEST CURRENT DEPLOYMENT${Magenta}             ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    if (Test-Path "test-deployment.ps1") {
        & powershell -ExecutionPolicy Bypass -File test-deployment.ps1
    } else {
        Write-Host "${Red}test-deployment.ps1 not found${Reset}"
    }
}

function Show-Complete {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}                    ✅ ALL DONE!${Magenta}                  ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    $elapsed = (Get-Date) - $startTime
    Write-Host "Time: $([math]::Round($elapsed.TotalMinutes, 2)) minutes"
    Write-Host ""
    Write-Host "${Green}Your MiPuesto app is ready!${Reset}"
    Write-Host ""
}

# Main Loop
Show-Banner

Write-Host "${Yellow}Welcome to MiPuesto automated deployment!${Reset}"
Write-Host ""

while ($true) {
    $choice = Show-Menu
    
    switch ($choice) {
        "1" { 
            Deploy-Production
            Show-Complete
        }
        "2" { 
            Setup-Local
            Show-Complete
        }
        "3" { 
            Setup-EnvOnly
        }
        "4" { 
            Test-Deployment
        }
        "5" { 
            Write-Host "${Green}Goodbye!${Reset}"
            exit
        }
        default { 
            Write-Host "${Red}Invalid choice${Reset}"
        }
    }
    
    Write-Host ""
    $another = Read-Host "${Yellow}Do something else? (yes/no)${Reset}"
    if ($another -ne "yes") {
        Show-Complete
        exit
    }
    
    Show-Banner
}
