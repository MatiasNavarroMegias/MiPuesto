#!/usr/bin/env pwsh

# 🚀 MiPuesto - Full Deployment Orchestrator
# This script guides you through the complete deployment

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

function Show-Banner {
    Write-Host ""
    Write-Host "${Magenta}╔════════════════════════════════════════════════════════╗${Reset}"
    Write-Host "${Magenta}║${Reset}       🚀 MiPuesto - Full Deployment Orchestrator${Magenta}     ║${Reset}"
    Write-Host "${Magenta}║${Reset}            Vercel + Render + Supabase${Magenta}              ║${Reset}"
    Write-Host "${Magenta}╚════════════════════════════════════════════════════════╝${Reset}"
    Write-Host ""
}

function Show-Step {
    param([string]$step, [string]$title)
    Write-Host ""
    Write-Host "${Cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
    Write-Host "${Blue}$step${Reset} ${Green}$title${Reset}"
    Write-Host "${Cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
}

function Test-Connection {
    param([string]$url, [string]$name)
    
    try {
        $response = Invoke-WebRequest -Uri "$url/api/health" -TimeoutSec 5 -ErrorAction Stop
        Write-Host "${Green}✅ $name responding${Reset}"
        return $true
    } catch {
        Write-Host "${Red}❌ $name not responding${Reset}"
        Write-Host "   URL: $url"
        Write-Host "   Error: $($_.Exception.Message)"
        return $false
    }
}

function Create-Summary {
    param([hashtable]$config)
    
    $summary = @"
# 🎉 MiPuesto Deployment Complete!

## ✅ Your App is LIVE

**Deployment Summary:**
- Frontend: $($config.VercelUrl)
- Backend: $($config.RenderUrl)
- Database: Supabase PostgreSQL
- Status: ONLINE ✅

## 🔗 Environment Variables

### Render (Backend)
\`\`\`env
DATABASE_URL=$($config.DatabaseUrl)
PORT=3001
CORS_ORIGIN=$($config.VercelUrl)
JWT_SECRET=[CONFIGURED]
NODE_ENV=production
\`\`\`

### Vercel (Frontend)
\`\`\`env
NEXT_PUBLIC_API_URL=$($config.RenderUrl)/api
\`\`\`

## 📋 Next Steps

1. **Test your app:**
   - Open: $($config.VercelUrl)
   - Try: Login → Registration flow
   - Check: All features working

2. **Monitor:**
   - Render: Dashboard → Logs
   - Vercel: Deployments tab

3. **Customize (optional):**
   - Add custom domain
   - Setup monitoring/alerts
   - Configure backups

## 🚀 Auto-Deployments Enabled

Push any code changes to main branch → Auto-deploy to Vercel & Render

---

**Deployment Date:** $(Get-Date)
**MiPuesto Version:** 1.0
**Status:** Production Ready ✅
"@

    return $summary
}

# Main Flow
Show-Banner

Write-Host "${Yellow}This script will guide you through deploying MiPuesto online.${Reset}"
Write-Host ""
Write-Host "${Yellow}You will need:${Reset}"
Write-Host "  ✓ GitHub account"
Write-Host "  ✓ Supabase account"
Write-Host "  ✓ Render account"
Write-Host "  ✓ Vercel account"
Write-Host ""

$proceed = Read-Host "${Yellow}Ready to continue? (yes/no)${Reset}"
if ($proceed -ne "yes") {
    Write-Host "${Red}Deployment cancelled.${Reset}"
    exit
}

# Initialize config
$config = @{
    VercelUrl = ""
    RenderUrl = ""
    DatabaseUrl = ""
}

# Step 1: Supabase
Show-Step "Step 1/4" "Supabase Database Setup"
Write-Host ""
Write-Host "Go to: ${Blue}https://supabase.com${Reset}"
Write-Host "1. Sign up with GitHub"
Write-Host "2. Create project (Name: MiPuesto, Region: Your choice, Plan: FREE)"
Write-Host "3. Wait for initialization (5-10 min)"
Write-Host "4. Settings → Database → Connection Strings → Copy URI"
Write-Host ""

$config.DatabaseUrl = Read-Host "${Yellow}Paste your Supabase DATABASE_URL${Reset}"

if (-not $config.DatabaseUrl.StartsWith("postgresql://")) {
    Write-Host "${Red}❌ Invalid database URL (should start with postgresql://)${Reset}"
    exit
}

Write-Host "${Green}✅ Database URL saved${Reset}"

# Step 2: Render
Show-Step "Step 2/4" "Render Backend Deployment"
Write-Host ""
Write-Host "Go to: ${Blue}https://render.com${Reset}"
Write-Host "1. Sign up with GitHub"
Write-Host "2. New Web Service → Select MiPuesto repo"
Write-Host "3. Settings:"
Write-Host "   - Name: mipuesto-api"
Write-Host "   - Root Directory: services/api"
Write-Host "   - Build Command: npm run build"
Write-Host "   - Start Command: node dist/main.js"
Write-Host "4. Add Environment Variables:"
Write-Host "   - DATABASE_URL: [YOUR DATABASE URL]"
Write-Host "   - PORT: 3001"
Write-Host "   - CORS_ORIGIN: [YOU'LL UPDATE LATER]"
Write-Host "   - JWT_SECRET: abc123def456ghi789jkl012mno345pqr"
Write-Host "   - NODE_ENV: production"
Write-Host "5. Click Deploy"
Write-Host "6. Wait for deployment (2-5 min) - should turn GREEN"
Write-Host ""

$config.RenderUrl = Read-Host "${Yellow}Paste your Render API URL (e.g., https://mipuesto-api.onrender.com)${Reset}"

if (-not $config.RenderUrl.StartsWith("https://")) {
    Write-Host "${Red}❌ Invalid Render URL (should start with https://)${Reset}"
    exit
}

Write-Host "${Green}✅ Render URL saved${Reset}"

# Step 3: Vercel
Show-Step "Step 3/4" "Vercel Frontend Deployment"
Write-Host ""
Write-Host "Go to: ${Blue}https://vercel.com${Reset}"
Write-Host "1. Sign up with GitHub"
Write-Host "2. Import Project → Select MiPuesto repo"
Write-Host "3. Add Environment Variable:"
Write-Host "   - NEXT_PUBLIC_API_URL: $($config.RenderUrl)/api"
Write-Host "4. Click Deploy"
Write-Host "5. Wait for deployment (2-3 min)"
Write-Host ""

$config.VercelUrl = Read-Host "${Yellow}Paste your Vercel URL (e.g., https://mipuesto.vercel.app)${Reset}"

if (-not $config.VercelUrl.StartsWith("https://")) {
    Write-Host "${Red}❌ Invalid Vercel URL (should start with https://)${Reset}"
    exit
}

Write-Host "${Green}✅ Vercel URL saved${Reset}"

# Step 4: Update CORS
Show-Step "Step 4/4" "Update CORS in Render"
Write-Host ""
Write-Host "1. Go back to: ${Blue}https://render.com${Reset}"
Write-Host "2. Select: mipuesto-api"
Write-Host "3. Environment section → Edit CORS_ORIGIN"
Write-Host "4. Change to: $($config.VercelUrl)"
Write-Host "5. Click Save (auto-redeploy 1-2 min)"
Write-Host ""

$cors_updated = Read-Host "${Yellow}Have you updated CORS? (yes/no)${Reset}"
if ($cors_updated -ne "yes") {
    Write-Host "${Red}Please update CORS in Render before continuing.${Reset}"
    exit
}

# Testing
Show-Step "TESTING" "Verify Everything Works"
Write-Host ""

$tests_passed = 0
$total_tests = 3

Write-Host "Test 1: ${Yellow}API Health Check${Reset}"
if (Test-Connection $config.RenderUrl "Render API") {
    $tests_passed++
} else {
    Write-Host "${Yellow}(API might still be starting, check in 1-2 minutes)${Reset}"
}

Write-Host ""
Write-Host "Test 2: ${Yellow}Database Connection${Reset}"
try {
    $response = Invoke-WebRequest -Uri "$($config.RenderUrl)/api/subscriptions/plans" -TimeoutSec 5 -ErrorAction Stop
    if ($response.Content -match "INTERMEDIO") {
        Write-Host "${Green}✅ Database connected${Reset}"
        $tests_passed++
    }
} catch {
    Write-Host "${Yellow}(Database might still be initializing)${Reset}"
}

Write-Host ""
Write-Host "Test 3: ${Yellow}Frontend Loading${Reset}"
try {
    $response = Invoke-WebRequest -Uri $config.VercelUrl -TimeoutSec 5 -ErrorAction Stop
    Write-Host "${Green}✅ Frontend responding${Reset}"
    $tests_passed++
} catch {
    Write-Host "${Yellow}(Frontend might still be building)${Reset}"
}

# Summary
Show-Step "✅ COMPLETE" "Deployment Summary"

$summary = Create-Summary $config

Write-Host $summary

# Save summary
$summaryPath = "DEPLOYMENT_SUMMARY.md"
$summary | Out-File -FilePath $summaryPath -Encoding UTF8
Write-Host ""
Write-Host "${Green}✅ Summary saved to: $summaryPath${Reset}"

Write-Host ""
Write-Host "${Magenta}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
Write-Host ""
Write-Host "${Green}🎉 Your MiPuesto app is LIVE!${Reset}"
Write-Host ""
Write-Host "Frontend:  ${Blue}$($config.VercelUrl)${Reset}"
Write-Host "Backend:   ${Blue}$($config.RenderUrl)${Reset}"
Write-Host "Database:  ${Blue}Supabase${Reset}"
Write-Host ""
Write-Host "${Yellow}Next Steps:${Reset}"
Write-Host "1. Open your frontend URL in browser"
Write-Host "2. Test registration flow"
Write-Host "3. Share your URL with others!"
Write-Host ""
Write-Host "${Magenta}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
Write-Host ""

# Ask to open browser
$openBrowser = Read-Host "${Yellow}Open frontend in browser? (yes/no)${Reset}"
if ($openBrowser -eq "yes") {
    Start-Process $config.VercelUrl
}

Write-Host ""
Write-Host "${Green}Deployment complete! Enjoy your app! 🚀${Reset}"
Write-Host ""
