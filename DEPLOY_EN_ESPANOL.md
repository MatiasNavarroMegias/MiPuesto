# 🚀 MIPUESTO ONLINE - INSTRUCCIONES 100% FUNCIONAL

## ⚡ PASO 1: SUPABASE (Base de Datos)

1. Abre: https://supabase.com
2. Sign up con GitHub
3. New Project:
   - Name: `MiPuesto`
   - Password: (guarda)
   - Region: La tuya
   - Plan: FREE
4. Espera 5-10 min
5. Settings → Database → Connection Strings
6. Copia el URI (postgresql://...)
7. **GUARDA ESTO**

---

## ⚡ PASO 2: RENDER (Backend API)

1. Abre: https://render.com
2. Sign up con GitHub
3. Click: \"New +\" → \"Web Service\"
4. Selecciona: MiPuesto repo
5. Rellenalo:
   - Name: `mipuesto-api`
   - Root Directory: `services/api`
   - Build Command: `npm run build`
   - Start Command: `node dist/main.js`
6. Click: \"Create Web Service\"
7. Scroll → Environment Variables → Add:
   ```
   DATABASE_URL=[PEGA DE SUPABASE]
   PORT=3001
   CORS_ORIGIN=https://[TU_URL_VERCEL]
   JWT_SECRET=[GENERA ABAJO]
   NODE_ENV=production
   ```
8. Para generar JWT_SECRET:
   ```bash
   # Windows PowerShell
   [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((New-Guid).ToString())) -replace '=', ''
   
   # macOS/Linux
   openssl rand -base64 32
   ```
9. Click: Save
10. Espera deploy (2-5 min)
11. Copia tu URL (ej: https://mipuesto-api.onrender.com)
12. **GUARDA ESTO**

---

## ⚡ PASO 3: VERCEL (Frontend)

1. Abre: https://vercel.com
2. Sign up con GitHub
3. \"Add New...\" → \"Project\"
4. \"Import Git Repository\"
5. Pega: https://github.com/TU_USERNAME/MiPuesto
6. Click: \"Import\"
7. Antes de Deploy, agrega:
   - NEXT_PUBLIC_API_URL = [URL_RENDER]/api
8. Click: \"Deploy\"
9. Espera build (2-3 min)
10. Copia tu URL (ej: https://mipuesto.vercel.app)
11. **GUARDA ESTO**

---

## ⚙️ PASO 4: ACTUALIZAR CORS en Render

1. Ve a Render dashboard
2. Click: mipuesto-api
3. Scroll → Environment
4. Edita CORS_ORIGIN:
   ```
   CORS_ORIGIN = https://mipuesto.vercel.app
   ```
5. Click: Save (auto-redeploy 1-2 min)

---

## ✅ VERIFICAR QUE FUNCIONA

```bash
# Test 1: API vivo
curl https://[TU_URL_RENDER]/api/health

# Test 2: Database conectada
curl https://[TU_URL_RENDER]/api/subscriptions/plans

# Test 3: Frontend
Abre: https://[TU_URL_VERCEL]
(Debe ver login)

# Test 4: Registro completo
1. Ve a: https://[TU_URL_VERCEL]/auth/registro
2. Rellena formulario
3. Click: Crear cuenta
4. Debe ir a /dashboard
```

---

## ✨ ¡LISTO!

Tu app está 100% online:

```
Frontend:  https://mipuesto.vercel.app
Backend:   https://mipuesto-api.onrender.com
Database:  Supabase
Cost:      $0 (GRATIS)
```

---

## 🐛 Si falla algo

**\"Cannot connect to database\"**
→ Verifica DATABASE_URL en Render

**\"CORS error\"**
→ Verifica CORS_ORIGIN es exacto (con https://)
→ Espera 2-3 min

**\"API da 500\"**
→ Abre Render → Logs tab
→ Busca el error

**\"Vercel build falla\"**
→ Vercel → Deployments → Ver logs
→ Verifica .env variables

---

## 📊 Resultado

- ✅ Frontend: Vercel (global, gratis)
- ✅ Backend: Render (gratis, puede dormir)
- ✅ Database: Supabase (5GB gratis)
- ✅ Auto-deploy: On git push
- ✅ Costo: $0/mes (o $7/mes sin sleep)

---

## 🎯 Próximos pasos

1. Share tu URL con users
2. (Opcional) Buy custom domain
3. (Opcional) Setup monitoring

---

**¡DEPLOY COMPLETADO! 🎉**

Tu MiPuesto está 100% funcional online.
