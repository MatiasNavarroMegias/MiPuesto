# 🚀 MIPUESTO - DEPLOY AUTOMÁTICO 100% ONLINE

> **Solo haz lo que dice aquí. Todo lo demás está automatizado.**

---

## ✨ ANTES DE EMPEZAR

Asegúrate de tener:
- [ ] GitHub account (para login)
- [ ] 15 minutos
- [ ] Este repositorio en tu GitHub

---

## 🎯 PASO 1: SUPABASE (3 minutos)

**Haz esto en tu navegador (sin cerrar esta ventana):**

1. Abre nueva tab: https://supabase.com
2. Click **"Start your project"**
3. Sign up con **GitHub**
4. Crea proyecto:
   - Name: `MiPuesto`
   - Password: copypaste esto → `masterkey123!`
   - Region: elige la tuya
   - Plan: FREE
5. **ESPERA** 5-10 minutos a que termine

**Cuando esté listo:**
6. Settings → Database → Connection Strings
7. Copia el string que empieza con `postgresql://`
8. **Pega aquí** (guárdalo):
   ```
   DATABASE_URL = [PEGA AQUÍ]
   ```

---

## 🎯 PASO 2: RENDER (5 minutos)

**En OTRA tab abre:**
https://render.com

1. Click **"Get Started"**
2. Sign up con **GitHub**
3. **Nuevo Web Service:**
   - Click: "New +" 
   - Click: "Web Service"
4. **Conectar repositorio:**
   - Select your MiPuesto repo
5. **Configurar:**
   ```
   Name: mipuesto-api
   Root Directory: services/api
   Environment: Node
   Build Command: npm run build
   Start Command: node dist/main.js
   ```
6. Click **"Create Web Service"**

**Espera a que aparezca el Dashboard (2-3 min)**

7. **Agrega Environment Variables:**
   - DATABASE_URL = [de Supabase arriba]
   - PORT = 3001
   - CORS_ORIGIN = https://mipuesto.vercel.app
   - JWT_SECRET = `abc123def456ghi789jkl012mno345pqr`
   - NODE_ENV = production

8. Click **"Save"**
9. **ESPERA** a que termine de deployar (2-5 min)

**Cuando esté DEPLOYED (verde):**
10. Copia tu URL (ej: https://mipuesto-api.onrender.com)
11. **Pega aquí:**
    ```
    RENDER_URL = [PEGA AQUÍ]
    ```

---

## 🎯 PASO 3: VERCEL (3 minutos)

**En OTRA tab abre:**
https://vercel.com

1. Click **"Start Deploying"**
2. Sign up con **GitHub**
3. Click: "Import Project"
4. Pega URL de tu repo:
   ```
   https://github.com/TU_USERNAME/MiPuesto
   ```
5. Click: "Import"
6. **Antes de Deploy, agrega:**
   - Variable: `NEXT_PUBLIC_API_URL`
   - Value: `[RENDER_URL]/api` (de arriba)
7. Click: **"Deploy"**

**ESPERA** a que termine (2-3 min)

**Cuando esté listo:**
8. Copia tu URL Vercel
9. **Pega aquí:**
   ```
   VERCEL_URL = [PEGA AQUÍ]
   ```

---

## 🎯 PASO 4: ACTUALIZAR CORS en Render (2 minutos)

**Vuelve a la tab de Render:**

1. Dashboard → mipuesto-api
2. Scroll a "Environment"
3. **Edita CORS_ORIGIN:**
   - Cambia a: `https://[TU_VERCEL_URL]`
4. Click: "Save"

**ESPERA** auto-redeploy (1-2 min)

---

## ✅ VERIFICAR QUE FUNCIONA

**Ejecuta este script en PowerShell:**

```powershell
# Reemplaza con tus URLs
$render = "https://mipuesto-api.onrender.com"
$vercel = "https://[TU_VERCEL_URL]"

# Test 1
Write-Host "Test 1: API vivo?"
curl "$render/api/health" -v

# Test 2
Write-Host "Test 2: Base de datos?"
curl "$render/api/subscriptions/plans"

# Test 3
Write-Host "Test 3: Frontend cargando?"
Start-Process $vercel
```

---

## 🎉 ¡LISTO!

Tu app está **100% ONLINE** en:

```
Frontend:  https://[TU_VERCEL_URL]
Backend:   https://[TU_RENDER_URL]
Database:  Supabase
Status:    LIVE ✅
```

---

## 📋 CHECKLIST FINAL

- [ ] Supabase running
- [ ] Render deployed (verde)
- [ ] Vercel deployed (verde)
- [ ] CORS actualizado en Render
- [ ] test script retorna OK
- [ ] Puedo abrir mi URL en navegador
- [ ] Veo página de login
- [ ] Puedo registrar usuario

---

## 🐛 Si algo falla

| Error | Solución |
|-------|----------|
| "Cannot connect" | DATABASE_URL en Render incorrecto |
| "CORS error" | CORS_ORIGIN en Render no coincide con Vercel |
| "500 error" | Ver logs en Render dashboard |
| "Build failed" | Ver logs en Vercel deployments |

---

**¡A FUNCIONAR!** 🚀
