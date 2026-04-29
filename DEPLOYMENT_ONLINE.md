# 🚀 DEPLOY MIPUESTO 100% ONLINE - Vercel + Render + Supabase

> **30 minutos para tener tu app completamente online**

---

## Stack Elegido

- **Frontend**: Vercel (Next.js)
- **Backend API**: Render.com (NestJS)
- **Database**: Supabase (PostgreSQL)
- **Cost**: ~FREE (con opción de $7+/mes para features premium)

---

## ⚡ 3 Pasos Simples

### **Paso 1: Crear Base de Datos en Supabase (5 minutos)**

1. Ve a **https://supabase.com**
2. Click en "Sign up" → Usa tu GitHub
3. Crea nuevo proyecto:
   - Name: `MiPuesto`
   - Database Password: (guarda en lugar seguro)
   - Region: La más cercana a tu ubicación
   - Plan: FREE
4. Espera a que se inicialice (5-10 minutos)
5. Ve a **Settings → Database → Connection Strings**
6. Copia el string en formato **URI** (comienza con `postgresql://`)
7. **Guarda esto** - lo necesitarás en el Paso 2

### **Paso 2: Deploy Backend en Render (10 minutos)**

1. Ve a **https://render.com**
2. Sign up con GitHub
3. Click en **"New +"** → **"Web Service"**
4. Selecciona tu repositorio **MiPuesto**
5. Completa los datos:
   - **Name**: `mipuesto-api`
   - **Root Directory**: `services/api`
   - **Environment**: Node
   - **Build Command**: `npm run build`
   - **Start Command**: `node dist/main.js`
6. Click en **"Create Web Service"**
7. Render abre la página del servicio. Scroll a la sección **"Environment"**
8. Agrega estas variables:

```
DATABASE_URL = [pegacopia de Supabase]
PORT = 3001
CORS_ORIGIN = https://[TU_URL_VERCEL] (agregar después)
JWT_SECRET = [generar abajo]
NODE_ENV = production
```

**Para generar JWT_SECRET**, corre en terminal:
```bash
# macOS/Linux
openssl rand -base64 32

# Windows PowerShell
[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((New-Guid).ToString())) -replace '=', ''
```

9. Click **"Save"** - Render comienza a deployar (2-5 minutos)
10. Una vez deployado, copia tu URL de Render (ej: `https://mipuesto-api.onrender.com`)
11. **Guarda esto** - lo necesitarás en Paso 3

### **Paso 3: Deploy Frontend en Vercel (5 minutos)**

1. Ve a **https://vercel.com**
2. Sign up con GitHub
3. Click **"Add New..."** → **"Project"**
4. Click **"Import Git Repository"**
5. Pega: `https://github.com/TU_USERNAME/MiPuesto`
6. Click **"Import"**
7. Vercel auto-detecta:
   - Framework: **Next.js** ✓
   - Root Directory: **apps/web** ✓
8. Antes de hacer click en Deploy, agrega variables de entorno:
   - Variable Name: `NEXT_PUBLIC_API_URL`
   - Value: `[TU_URL_RENDER]/api` (del Paso 2)
9. Click **"Deploy"**
10. Espera el build (2-3 minutos)
11. Vercel te da tu URL (ej: `https://mipuesto.vercel.app`)

---

## ⚙️ Actualizar CORS en Render (IMPORTANTE!)

Ahora que tienes tu URL de Vercel:

1. Ve a **Render dashboard** → **mipuesto-api**
2. Scroll a **Environment**
3. Edita `CORS_ORIGIN`:
   ```
   CORS_ORIGIN = https://mipuesto.vercel.app
   ```
4. Click **"Save"** - Render auto-redeploy (1-2 minutos)

---

## ✅ Verificar Que Todo Funciona

### Test 1: API está respondiendo
```bash
curl https://[TU_URL_RENDER]/api/health
# Debe retornar: {"status":"ok"}
```

### Test 2: Conectar a Base de Datos
```bash
curl https://[TU_URL_RENDER]/api/subscriptions/plans
# Debe retornar lista de 3 planes
```

### Test 3: Frontend cargó
1. Ve a `https://[TU_URL_VERCEL]`
2. Debe ver página de login
3. Abre DevTools (F12) → Network → Verifica que calls van a tu URL de Render

### Test 4: Flow completo de registro
1. Ve a `https://[TU_URL_VERCEL]/auth/registro`
2. Rellena:
   - Organization: "Test Company"
   - Full Name: "Test User"
   - Email: "test@example.com"
   - Password: "Test1234"
3. Click "Crear cuenta"
4. Debe redirigir a `/dashboard`
5. Verifica que el plan sea "BASE"

---

## 🐛 Si Algo Falla

### Error: "Cannot connect to database"
- Verifica que DATABASE_URL en Render sea correcta
- Chequea que Supabase database está running
- Asegúrate que no hay espacios extra en la URL

### Error: "CORS error" (acceso denegado desde frontend)
- Verifica CORS_ORIGIN en Render matches exactamente tu URL de Vercel
- Incluye `https://` (sin trailing slash)
- Espera 2-3 minutos después de cambiar CORS (Render redeploy automático)

### Error: "Vercel build falla"
- Chequea Vercel Deployments tab para logs
- Verifica que `.env` variables están seteadas
- Intenta hacer re-deploy

### Error: "API retorna 500"
- Abre Render dashboard → mipuesto-api → Logs
- Busca el error en los logs
- Verifica DATABASE_URL format sea correcto
- Chequea JWT_SECRET tiene 32+ caracteres

---

## 🔄 Después de Setup: Auto-Deployments

Una vez todo está running:

- **Push a main branch** → Auto-deploy a Vercel + Render
- **Ver status en:**
  - Render: Dashboard → mipuesto-api → Deployments
  - Vercel: Dashboard → Deployments

---

## 📊 Arquitectura Final

```
Usuarios en Browser
         ↓
https://mipuesto.vercel.app (Vercel CDN Global)
         ↓ (REST API calls)
https://api-mipuesto.onrender.com (Render NestJS)
         ↓ (SQL queries)
Supabase PostgreSQL Database
```

---

## 💰 Costo

| Servicio | Función | Costo |
|----------|---------|-------|
| Supabase | Base de Datos | FREE (5GB) |
| Render | API Backend | FREE (con sleep mode en inactividad) |
| Vercel | Frontend | FREE |
| **TOTAL** | | **GRATIS** |

**Nota**: Para remover sleep mode en Render, puedes:
- Pagar $7/mes (Starter plan)
- O es gratis si usas plan gratuito (con pausa después 15 min inactividad)

---

## 🎯 Comandos Útiles Para Testing

```bash
# Ver health del API
curl https://tu-render-url/api/health -v

# Ver subscription plans (verifica BD)
curl https://tu-render-url/api/subscriptions/plans | jq .

# Test CORS (desde tu laptop)
curl -H "Origin: https://tu-vercel-url" \
     https://tu-render-url/api/health \
     -H "Access-Control-Request-Method: GET" \
     -H "Access-Control-Request-Headers: content-type" \
     -v

# Check si API está vivo
while true; do curl -s https://tu-render-url/api/health && echo "" || echo "DOWN"; sleep 30; done
```

---

## 📝 Variables Finales de Entorno

### Render (Backend)
```env
DATABASE_URL=postgresql://user:pass@db.supabase.co:5432/postgres
PORT=3001
CORS_ORIGIN=https://mipuesto.vercel.app
JWT_SECRET=GenerateStrongString32CharsMinimum
NODE_ENV=production
```

### Vercel (Frontend)
```env
NEXT_PUBLIC_API_URL=https://mipuesto-api.onrender.com/api
```

---

## 🎉 ¡LISTA!

Tu app está 100% online con:
- ✅ Frontend en Vercel
- ✅ Backend en Render
- ✅ Database en Supabase
- ✅ Auto-deployments configurados
- ✅ Monitoreo disponible
- ✅ GRATIS (o casi)

---

## 📞 Links Útiles

- **Render Docs**: https://render.com/docs
- **Vercel Docs**: https://vercel.com/docs
- **Supabase Docs**: https://supabase.com/docs
- **NestJS**: https://docs.nestjs.com
- **Next.js**: https://nextjs.org/docs

---

**¡A lanzar!** 🚀
