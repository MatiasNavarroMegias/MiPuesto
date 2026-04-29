# 🤖 MiPuesto - Automated Deployment Scripts

Everything is now **100% automated**. Choose what you want and let the scripts do it.

---

## 🚀 QUICK START - 3 COMMANDS

### Production Deployment (20 minutes, minimal clicks)
```powershell
powershell -ExecutionPolicy Bypass -File mipuesto.ps1
# Choose: 1 (Deploy to Production)
```

### Local Development Setup (10 minutes)
```powershell
powershell -ExecutionPolicy Bypass -File mipuesto.ps1
# Choose: 2 (Setup Local Development)
```

### Just Configure Environment Variables
```powershell
powershell -ExecutionPolicy Bypass -File setup-env.ps1
```

---

## 📋 What Each Script Does

### **mipuesto.ps1** - MASTER SCRIPT (START HERE)
Main menu with 4 options:
- **Option 1**: Deploy to Production (Supabase + Render + Vercel)
- **Option 2**: Setup Local Development
- **Option 3**: Configure Environment Variables Only
- **Option 4**: Test Current Deployment

### **deploy-auto.ps1** - Full Automation
- Installs CLI tools automatically
- Opens browsers at right URLs
- Guides you through each step
- Verifies deployment works
- Creates summary report

### **setup-env.ps1** - Environment Configuration
- Creates all `.env` files
- Auto-generates secrets
- Sets CORS, API URLs, database connection
- Works for both dev and production

### **test-deployment.ps1** - Verification
- Tests API health check
- Tests database connection
- Tests frontend loading
- Identifies problems

---

## 🎯 Which One to Use?

**Just want to deploy?**
```powershell
powershell -ExecutionPolicy Bypass -File mipuesto.ps1
# Pick option 1
```

**Just setting up local dev?**
```powershell
powershell -ExecutionPolicy Bypass -File mipuesto.ps1
# Pick option 2
```

**Need to fix environment variables?**
```powershell
powershell -ExecutionPolicy Bypass -File setup-env.ps1
```

**Something not working?**
```powershell
powershell -ExecutionPolicy Bypass -File test-deployment.ps1
```

---

## 📊 Automation Level

| Script | Automation | Manual Work | Time |
|--------|-----------|-------------|------|
| **mipuesto.ps1 (option 1)** | 80% | Click "Deploy" on platforms | 20 min |
| **deploy-auto.ps1** | 70% | Click "Deploy" on platforms | 25 min |
| **setup-env.ps1** | 100% | Just paste URLs | 5 min |
| **test-deployment.ps1** | 100% | Just read output | 2 min |

---

## 🔄 Step-by-Step Flow

### Deployment to Production

```
1. Run: mipuesto.ps1
   ↓
2. Choose: "1 - Deploy to Production"
   ↓
3. Script runs setup-env.ps1
   • Ask: Supabase DATABASE_URL
   • Auto-generate JWT secret
   • Ask: Render URL (after you deploy)
   • Ask: Vercel URL (after you deploy)
   ↓
4. Script runs deploy-auto.ps1
   • Open Supabase → Create project
   • Open Render → Deploy backend
   • Open Vercel → Deploy frontend
   • Update CORS in Render
   • Verify everything works
   ↓
5. ✅ APP IS LIVE
```

### Local Development

```
1. Run: mipuesto.ps1
   ↓
2. Choose: "2 - Setup Local Development"
   ↓
3. Script runs setup-env.ps1
   • Creates .env files for local dev
   ↓
4. Auto installs dependencies
   • pnpm install
   ↓
5. Auto sets up database
   • Prisma migrate
   • Seed data
   ↓
6. Auto builds project
   • pnpm build
   ↓
7. ✅ Ready to dev
   • pnpm --filter @mipuesto/web dev
```

---

## 🎨 What Gets Automated

### ✅ FULLY AUTOMATED
- ✓ Environment variable generation
- ✓ Secret generation (JWT_SECRET)
- ✓ ENV file creation
- ✓ Database seed
- ✓ Build process
- ✓ Testing verification
- ✓ Browser opening
- ✓ Deployment verification

### 🤔 SEMI-AUTOMATED (1 click each)
- ⚠️ Create Supabase project (you click "Create Project")
- ⚠️ Deploy to Render (you click "Deploy")
- ⚠️ Deploy to Vercel (you click "Deploy")
- ⚠️ Update CORS (you click "Save")

### ❌ CAN'T BE AUTOMATED
- ✗ GitHub login (OAuth needs browser)
- ✗ Platform sign-up (requires email verification)

---

## 📝 Environment Variables Created

### services/api/.env
```env
DATABASE_URL=postgresql://...
PORT=3001
CORS_ORIGIN=https://mipuesto.vercel.app
JWT_SECRET=abc123...
NODE_ENV=production
LOG_LEVEL=debug
```

### apps/web/.env.local
```env
NEXT_PUBLIC_API_URL=https://mipuesto-api.onrender.com/api
```

### database/.env
```env
DATABASE_URL=postgresql://...
```

---

## 🆘 Troubleshooting

### "PowerShell script disabled"
```powershell
# Run this once:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

# Then run scripts normally:
./mipuesto.ps1
```

### "npm not found"
Install Node.js from https://nodejs.org

### "pnpm not found"
```powershell
npm install -g pnpm
```

### "CLI installation fails"
```powershell
npm install -g vercel @render-cli/cli
```

### "Deployment stuck"
Check logs:
- Render: https://dashboard.render.com → mipuesto-api → Logs
- Vercel: https://vercel.com → Select project → Deployments

---

## 🎯 Success Criteria

After running scripts:
- [ ] `services/api/.env` exists
- [ ] `apps/web/.env.local` exists
- [ ] `database/.env` exists
- [ ] All 3 platform URLs received
- [ ] Frontend loads without errors
- [ ] Backend health check responds
- [ ] Database connection works

---

## 📚 All Available Scripts

```
mipuesto.ps1          ← START HERE (master menu)
deploy-auto.ps1       ← Full production deployment
setup-env.ps1         ← Environment configuration
test-deployment.ps1   ← Verify everything works
deploy-full.ps1       ← Interactive guided deployment
deploy-rapido.ps1     ← Spanish ultra-simple guide
```

---

## 🚀 Let's Go!

**Start here:**
```powershell
powershell -ExecutionPolicy Bypass -File mipuesto.ps1
```

**Your app will be online in 20-30 minutes.**

Any questions? Check individual script files - they have comments!

---

**Made with ❤️ for MiPuesto**
