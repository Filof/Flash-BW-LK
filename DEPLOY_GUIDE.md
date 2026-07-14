# 🚀 Guía de Despliegue - FlashBrowser en Render

## 📋 Requisitos

- Cuenta en [Render.com](https://render.com) (gratuita)
- Repositorio GitHub con el código de FlashBrowser
- Cliente VNC en Android (TightVNC Viewer o similar)

---

## 🔧 Pasos para Despliegue en Render

### 1️⃣ Preparar el Repositorio

```bash
# Asegúrate de que estos archivos estén en la raíz:
# - start.sh (script de inicio)
# - Dockerfile (configuración del contenedor)
# - render.yaml (opcional, para configuración avanzada)
```

### 2️⃣ Conectar con GitHub

1. Ve a [Render Dashboard](https://dashboard.render.com)
2. Haz clic en **"New +"** → **"Web Service"**
3. Selecciona **"Connect a Repository"**
4. Autoriza Render para acceder a tu GitHub
5. Selecciona el repositorio con FlashBrowser

### 3️⃣ Configurar el Servicio

- **Name**: `flashbrowser-game`
- **Environment**: `Docker`
- **Region**: Selecciona la más cercana a ti (ej: Ohio, Oregon)
- **Branch**: `main` (o la que uses)
- **Build Command**: (dejar vacío, lo hace el Dockerfile)
- **Start Command**: (dejar vacío, lo hace el Dockerfile)

### 4️⃣ Variables de Entorno

En la sección **"Environment"**, agrega:

```
DISPLAY=:99
LIBGL_ALWAYS_INDIRECT=1
QT_QPA_PLATFORM=offscreen
```

### 5️⃣ Seleccionar Plan

- **Plan**: `Starter` (mínimo, ~$7/mes) o `Free Trial` (30 días gratis)
- **Resources**: 
  - 0.5 CPU
  - 1 GB RAM (mínimo)

### 6️⃣ Desplegar

Haz clic en **"Create Web Service"** y espera a que se complete el build (5-10 minutos).

---

## 📱 Conectar desde Android

### En Render Dashboard:

1. Anota tu **URL del servicio** (ej: `flashbrowser-xyz.onrender.com`)
2. El puerto VNC será `5901`

### En Android:

1. Descarga **TightVNC Viewer** desde Play Store
2. Nueva conexión:
   - **Address**: `flashbrowser-xyz.onrender.com`
   - **Port**: `5901`
   - **Password**: `123456` (cambia en `start.sh` si quieres)
3. ¡Conecta y disfruta del juego!

---

## 🎮 Acceder al Juego

- **URL en el servidor**: https://www.mnfclub.com/game-windows.html
- **Acceso remoto**: VNC desde Android
- **El servidor** ejecuta todo
- **Android** solo muestra la pantalla

---

## ⚙️ Personalización

### Cambiar Puerto VNC

En `start.sh`, línea:
```bash
vncserver :1 -geometry 1280x720 -depth 24 -name "FlashGame"
```

### Cambiar Resolución

```bash
# En start.sh y Dockerfile:
-geometry 1920x1080  # para Full HD
-geometry 1280x720   # para HD (actual)
```

### Cambiar Contraseña VNC

En `start.sh`, línea:
```bash
echo "TU_NUEVA_CONTRASEÑA" | vncpasswd -f > ~/.vnc/passwd
```

---

## 🐛 Solución de Problemas

### No puedo conectar desde Android

```bash
# Verifica que VNC esté corriendo en el servidor Render
# En los logs de Render deberías ver:
# "Servidor VNC disponible en: localhost:5901"
```

### El juego se ve lento

- Reduce resolución: `-geometry 1024x576`
- Aumenta el plan de Render (mejor CPU)
- Usa una red WiFi en lugar de datos móviles

### FlashBrowser no inicia

- Verifica los **logs** en Render Dashboard
- Asegúrate de que `browser.html` esté modificado correctamente
- Comprueba que el `Dockerfile` sea accesible

---

## 💾 Archivos Generados

```
FlashBrowser-linux-x64/
├── start.sh          ← Script de inicialización
├── Dockerfile        ← Configuración de contenedor
├── render.yaml       ← Config alternativa (opcional)
└── DEPLOY_GUIDE.md   ← Este archivo
```

---

## 📊 Monitoreo

En **Render Dashboard**:
- Ver logs en tiempo real
- Monitorear CPU y memoria
- Reiniciar servicio si es necesario
- Ver estadísticas de conexión

---

## 🔒 Seguridad (Importante)

⚠️ **CAMBIOS RECOMENDADOS PARA PRODUCCIÓN:**

1. **Usa HTTPS**: Render lo proporciona automáticamente
2. **Cambia la contraseña VNC** (no uses `123456`)
3. **Restricción de IP**: Si es posible, solo desde tu Android
4. **Firewall**: Configura Render para solo aceptar conexiones VNC

---

## 📞 Soporte

Si algo falla:
- Revisa los **logs** en Render
- Comprueba que todos los archivos estén correctamente copiados
- Asegúrate de que el Dockerfile sea válido
- Prueba localmente con: `bash start.sh`

---

**¡Listo! 🎉 Ahora deberías poder jugar desde tu Android con el servidor ejecutando en Render.**
