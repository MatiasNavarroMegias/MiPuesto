#!/usr/bin/env pwsh
# Auto Deployment Script

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
Write-Host "$Magenta|$Reset        AUTOMATED DEPLOYMENT GUIDE$Magenta              |$Reset"
Write-Host "$Magenta=========================================================$Reset"
Write-Host ""

Write-Host "Follow these steps:"
Write-Host ""

# Step 1 - Supabase
Write-Host "$Blue[Step 1]$Reset Supabase Database"
Write-Host "  1. Open: https://supabase.com"
Write-Host "  2. Sign up with GitHub"
Write-Host "  3. Create new project (Name: MiPuesto)"
Write-Host "  4. Wait for initialization (5-10 min)"
Write-Host "  5. Settings > Connection Strings > Copy PostgreSQL URL"
Write-Host ""
Write-Host "Press Enter when database is created..."
Read-Host

# Step 2 - Render
Write-Host ""
Write-Host "$Blue[Step 2]$Reset Render Backend Deployment"
Write-Host "  1. Open: https://render.com"
Write-Host "  2. Sign up with GitHub"
Write-Host "  3. New Web Service > Select MiPuesto repo"
Write-Host "  4. Name: mipuesto-api"
Write-Host "  5. Root: services/api"
Write-Host "  6. Build: npm run build"
Write-Host "  7. Start: node dist/main.js"
Write-Host "  8. Add Environment Variables (from .env file)"
Write-Host "  9. Deploy and wait for GREEN status"
Write-Host ""
Write-Host "Press Enter when deployed..."
Read-Host

# Step 3 - Vercel
Write-Host ""
Write-Host "$Blue[Step 3]$Reset Vercel Frontend Deployment"
Write-Host "  1. Open: https://vercel.com"
Write-Host "  2. Sign up with GitHub"
Write-Host "  3. Import Project > Select MiPuesto repo"
Write-Host "  4. Add: NEXT_PUBLIC_API_URL = (your Render URL)/api"
Write-Host "  5. Deploy and wait for completion"
Write-Host ""
Write-Host "Press Enter when deployed..."
Read-Host

# Step 4 - CORS
Write-Host ""
Write-Host "$Blue[Step 4]$Reset Update CORS"
Write-Host "  1. Go back to: https://render.com"
Write-Host "  2. Select: mipuesto-api"
Write-Host "  3. Environment section"
Write-Host "  4. Edit: CORS_ORIGIN = (your Vercel URL)"
Write-Host "  5. Save (auto-redeploy)"
Write-Host ""
Write-Host "Press Enter when CORS is updated..."
Read-Host

# Verification
Write-Host ""
Write-Host "$Magenta=========================================================$Reset"
Write-Host "$Green Deployment Complete!$Reset"
Write-Host "$Magenta=========================================================$Reset"
Write-Host ""
Write-Host "Your app is now online!"
Write-Host ""
