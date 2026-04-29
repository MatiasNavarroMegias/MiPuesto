# 🚀 HAZLO ASÍ - 3 PASOS, 15 MINUTOS

## Paso 1: Database (5 min)

```
https://supabase.com
→ Sign up con GitHub
→ New Project (MiPuesto)
→ Settings → Connection Strings
→ Copia URL que empieza con postgresql://
→ GUARDA ESTO
```

## Paso 2: Backend (5 min)

```
https://render.com
→ Sign up con GitHub
→ New Web Service
→ Select MiPuesto repo
→ Name: mipuesto-api
→ Root: services/api
→ Build: npm run build
→ Start: node dist/main.js
→ Environment Variables:
   - DATABASE_URL = [DE ARRIBA]
   - PORT = 3001
   - CORS_ORIGIN = https://mipuesto.vercel.app
   - JWT_SECRET = abc123def456ghi789jkl012mno345pqr
   - NODE_ENV = production
→ Deploy
→ ESPERA hasta que sea VERDE
→ Copia tu URL (ej: https://mipuesto-api.onrender.com)
→ GUARDA ESTO
```

## Paso 3: Frontend (3 min)

```
https://vercel.com
→ Sign up con GitHub
→ Import Project
→ Select MiPuesto repo
→ Environment Variable:
   - NEXT_PUBLIC_API_URL = [URL_RENDER]/api
→ Deploy
→ ESPERA 2-3 min
→ Copia tu URL
→ GUARDA ESTO
```

## Paso 4: Actualizar CORS (2 min)

```
https://render.com
→ mipuesto-api project
→ Environment section
→ Edita CORS_ORIGIN
→ Cambia a: https://[TU_VERCEL_URL]
→ Save
→ Auto-redeploy
```

## ✅ Verificar

```bash
powershell -ExecutionPolicy Bypass -File deploy-full.ps1
```

O manual:
```
curl https://[TU_RENDER_URL]/api/health
curl https://[TU_RENDER_URL]/api/subscriptions/plans
abre https://[TU_VERCEL_URL] en navegador
```

## 🎉 ¡LISTO!

Tu app está online:
- Frontend: https://mipuesto.vercel.app
- Backend: https://mipuesto-api.onrender.com
- Database: Supabase

---

**¡A trabajar!** 🚀
