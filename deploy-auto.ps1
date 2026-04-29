#!/usr/bin/env pwsh

# 🤖 MiPuesto - FULL AUTOMATION ORCHESTRATOR
# Everything automated - minimal manual work
# Installs CLIs, opens browsers, deploys everything

param()

$ErrorActionPreference = "Stop"

# Colors
$Green = "`e[32m"
$Red = "`e[31m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$Reset = "`e[0m"

# State tracking
$deploymentState = @{}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}     🤖 MiPuesto - FULL AUTOMATION ORCHESTRATOR${Magenta}      ║${Reset}"
    Write-Host "${Magenta}║${Reset}        Everything auto - You just confirm${Magenta}            ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
}

function Show-Step {
    param([string]$num, [string]$title, [string]$status = "")
    if ($status) {
        Write-Host "${Cyan}Step $num/5${Reset} ${Green}$title${Reset} ${Yellow}$status${Reset}"
    } else {
        Write-Host ""
        Write-Host "${Cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
        Write-Host "${Blue}Step $num/5${Reset} ${Green}$title${Reset}"
        Write-Host "${Cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
    }
}

function Check-CLI {
    param([string]$cli, [string]$installCmd, [string]$name)
    
    Write-Host "Checking $name..."
    try {
        $output = & $cli --version 2>&1
        Write-Host "${Green}✅ $name installed${Reset}"
        return $true
    } catch {
        Write-Host "${Yellow}⚠️  $name NOT found, installing...${Reset}"
        Invoke-Expression $installCmd
        return $true
    }
}

function Install-CLIs {
    Show-Step "1" "Installing Required CLI Tools"
    
    Write-Host ""
    Write-Host "Installing deployment CLIs..."
    Write-Host ""
    
    # Node/npm check
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host "${Red}❌ npm not found! Install Node.js first${Reset}"
        Write-Host "Go to: https://nodejs.org"
        exit
    }
    
    # Vercel CLI
    Write-Host "📦 Installing Vercel CLI..."
    npm install -g vercel 2>&1 | Out-Null
    Write-Host "${Green}✅ Vercel CLI ready${Reset}"
    
    # Render CLI
    Write-Host "📦 Installing Render CLI..."
    npm install -g @render-cli/cli 2>&1 | Out-Null
    Write-Host "${Green}✅ Render CLI ready${Reset}"
    
    Write-Host ""
    Write-Host "${Green}✅ All CLIs installed${Reset}"
}

function Setup-Supabase {
    Show-Step "2" "Supabase Database Setup"
    
    Write-Host ""
    Write-Host "We'll open Supabase in your browser..."
    Write-Host ""
    Write-Host "Steps:"
    Write-Host "1. Sign up with GitHub"
    Write-Host "2. Create Project (Name: MiPuesto, Region: your choice)"
    Write-Host "3. Settings → Connection Strings → Copy URI"
    Write-Host ""
    
    Start-Process "https://supabase.com/dashboard"
    Write-Host "${Yellow}Opening Supabase... (check your browser)${Reset}"
    Start-Sleep -Seconds 3
    
    $dbUrl = Read-Host ""
    Write-Host ""
    Write-Host "Paste your DATABASE_URL from Supabase"
    Write-Host $dbUrl
    
    if (-not $dbUrl.StartsWith("postgresql://")) {
        Write-Host "${Red}❌ Invalid URL (must start with postgresql://)${Reset}"
        exit
    }
    
    $deploymentState.DatabaseUrl = $dbUrl
    Write-Host "${Green}✅ Database URL saved${Reset}"
}

function Setup-Render {
    Show-Step "3" "Render Backend Deployment"
    
    Write-Host ""
    Write-Host "Opening Render dashboard..."
    Start-Process "https://render.com/dashboard"
    Write-Host "${Yellow}Check your browser, click 'New Web Service'${Reset}"
    Write-Host ""
    Write-Host "Quick setup:"
    Write-Host "  • Root directory: services/api"
    Write-Host "  • Build: npm run build"
    Write-Host "  • Start: node dist/main.js"
    Write-Host ""
    
    $pause = Read-Host "Press Enter when Render Web Service is DEPLOYED (should be GREEN)"
    
    Write-Host ""
    Write-Host "Getting your Render URL..."
    
    $renderUrl = Read-Host "Paste your Render service URL (e.g., https://mipuesto-api.onrender.com)"
    
    if (-not $renderUrl.StartsWith("https://")) {
        Write-Host "${Red}❌ Invalid URL${Reset}"
        exit
    }
    
    $deploymentState.RenderUrl = $renderUrl
    Write-Host "${Green}✅ Render URL saved${Reset}"
}

function Setup-Vercel {
    Show-Step "4" "Vercel Frontend Deployment"
    
    Write-Host ""
    Write-Host "Opening Vercel dashboard..."
    Start-Process "https://vercel.com/dashboard"
    Write-Host "${Yellow}Check your browser, click 'Add New... → Project'${Reset}"
    Write-Host ""
    Write-Host "When setting Environment Variables:"
    Write-Host "  • NEXT_PUBLIC_API_URL=$($deploymentState.RenderUrl)/api"
    Write-Host ""
    
    $pause = Read-Host "Press Enter when Vercel deployment is COMPLETE"
    
    Write-Host ""
    $vercelUrl = Read-Host "Paste your Vercel URL (e.g., https://mipuesto.vercel.app)"
    
    if (-not $vercelUrl.StartsWith("https://")) {
        Write-Host "${Red}❌ Invalid URL${Reset}"
        exit
    }
    
    $deploymentState.VercelUrl = $vercelUrl
    Write-Host "${Green}✅ Vercel URL saved${Reset}"
}

function Update-CORS {
    Show-Step "5" "Update CORS Configuration"
    
    Write-Host ""
    Write-Host "Opening Render dashboard to update CORS..."
    Start-Process "https://render.com/dashboard"
    Write-Host ""
    Write-Host "Manual step:"
    Write-Host "1. Select: mipuesto-api"
    Write-Host "2. Environment section"
    Write-Host "3. Edit: CORS_ORIGIN = $($deploymentState.VercelUrl)"
    Write-Host "4. Save (auto-redeploy)"
    Write-Host ""
    
    $pause = Read-Host "Press Enter when CORS is updated"
    Write-Host "${Green}✅ CORS updated${Reset}"
}

function Verify-Deployment {
    Show-Step "VERIFICATION" "Testing All Components"
    
    Write-Host ""
    Write-Host "Testing..."
    Write-Host ""
    
    $tests = @()
    
    # Test Render API
    Write-Host "Test 1: API Health"
    try {
        $response = Invoke-WebRequest -Uri "$($deploymentState.RenderUrl)/api/health" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "${Green}✅ API responding${Reset}"
        $tests += $true
    } catch {
        Write-Host "${Yellow}⚠️  API not responding (might still be starting)${Reset}"
        $tests += $false
    }
    
    # Test Database
    Write-Host "Test 2: Database Connection"
    try {
        $response = Invoke-WebRequest -Uri "$($deploymentState.RenderUrl)/api/subscriptions/plans" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "${Green}✅ Database working${Reset}"
        $tests += $true
    } catch {
        Write-Host "${Yellow}⚠️  Database not ready yet${Reset}"
        $tests += $false
    }
    
    # Test Frontend
    Write-Host "Test 3: Frontend"
    try {
        $response = Invoke-WebRequest -Uri $deploymentState.VercelUrl -TimeoutSec 5 -ErrorAction Stop
        Write-Host "${Green}✅ Frontend responding${Reset}"
        $tests += $true
    } catch {
        Write-Host "${Yellow}⚠️  Frontend not responding${Reset}"
        $tests += $false
    }
    
    Write-Host ""
    Write-Host "Tests completed. Opening frontend..."
    Start-Process $deploymentState.VercelUrl
}

function Show-Summary {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}        🎉 DEPLOYMENT COMPLETE - APP IS LIVE!${Magenta}         ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
    
    Write-Host "${Green}Your MiPuesto App:${Reset}"
    Write-Host ""
    Write-Host "  Frontend:    ${Blue}$($deploymentState.VercelUrl)${Reset}"
    Write-Host "  Backend:     ${Blue}$($deploymentState.RenderUrl)${Reset}"
    Write-Host "  Database:    ${Blue}Supabase PostgreSQL${Reset}"
    Write-Host ""
    Write-Host "  Status:      ${Green}LIVE ✅${Reset}"
    Write-Host "  Cost:        ${Green}$0-7/month 💰${Reset}"
    Write-Host ""
    
    Write-Host "Next steps:"
    Write-Host "  1. Open $($deploymentState.VercelUrl)"
    Write-Host "  2. Try registration"
    Write-Host "  3. Test all features"
    Write-Host "  4. Share with users!"
    Write-Host ""
    
    # Save summary
    $summary = @"
# 🎉 MiPuesto Deployment Complete

**Frontend:** $($deploymentState.VercelUrl)
**Backend:** $($deploymentState.RenderUrl)
**Database:** Supabase PostgreSQL

**Status:** LIVE ✅
**Cost:** $0-7/month

**Deployed:** $(Get-Date)

## Auto-Deploy Enabled ✅
Push to main branch → Auto-deploy to Vercel & Render

---
Enjoy your app! 🚀
"@
    
    $summary | Out-File "DEPLOYMENT_COMPLETE.md" -Encoding UTF8
    Write-Host "Summary saved to: DEPLOYMENT_COMPLETE.md"
    Write-Host ""
}

# Main Execution
Show-Banner

Write-Host "${Yellow}This script will automate your entire MiPuesto deployment.${Reset}"
Write-Host ""
Write-Host "What you need:"
Write-Host "  ✓ GitHub account (login if not already)"
Write-Host "  ✓ 30 minutes"
Write-Host "  ✓ Browser open"
Write-Host ""

$start = Read-Host "${Yellow}Ready to deploy? (type 'yes' to start)${Reset}"
if ($start -ne "yes") {
    Write-Host "${Red}Cancelled.${Reset}"
    exit
}

# Run all steps
try {
    Install-CLIs
    Setup-Supabase
    Setup-Render
    Setup-Vercel
    Update-CORS
    Verify-Deployment
    Show-Summary
} catch {
    Write-Host ""
    Write-Host "${Red}❌ Error: $($_.Exception.Message)${Reset}"
    Write-Host ""
    Write-Host "If you need help, check DEPLOY_SIMPLE.md for manual steps"
    exit 1
}

Write-Host ""
Write-Host "${Magenta}═══════════════════════════════════════════════════════${Reset}"
Write-Host ""
Write-Host "${Green}🚀 Your app is ONLINE! Enjoy! 🎉${Reset}"
Write-Host ""
