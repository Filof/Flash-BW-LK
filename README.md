# 🎮 FlashBrowser - Juego Flash en Servidor Linux

Este es **FlashBrowser** modificado para ejecutarse en un **servidor Linux sin GUI** (Render.com) y ser controlado remotamente desde **Android** mediante VNC.

## 🎯 Características

✅ Ejecutable en Linux sin interfaz gráfica  
✅ Soporte para juegos Flash (Pepper Flash integrado)  
✅ Acceso remoto desde Android via VNC  
✅ Compatible con Render.com (Deploy en 5 minutos)  
✅ Streaming de video en tiempo real  
✅ Bajo consumo de CPU (software rendering)  

---

## 📱 Arquitectura

```
┌──────────────────────────────────────────────────┐
│             Android (Pantalla)                    │
│  ┌──────────────────────────────────────────┐   │
│  │  TightVNC Viewer / RDP Client             │   │
│  │  Visualiza gráficos del juego            │   │
│  └──────────────────┬───────────────────────┘   │
└─────────────────────┼──────────────────────────┘
                      │ TCP 5901 (VNC)
                      │
┌─────────────────────▼──────────────────────────┐
│        Render.com - Linux Server                │
│  ┌──────────────────────────────────────────┐  │
│  │  FlashBrowser                             │  │
│  │  - URL: https://www.mnfclub.com/...      │  │
│  │  - Chromium + Pepper Flash                │  │
│  │  - Ejecuta lógica del juego               │  │
│  │                                           │  │
│  │  Xvfb (Pantalla Virtual)                  │  │
│  │  - Renderiza gráficos sin GPU             │  │
│  │                                           │  │
│  │  VNC Server                               │  │
│  │  - Transmite pantalla a Android           │  │
│  └──────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

---

## 🚀 Inicio Rápido (Render)

### 1. Prepara el Repositorio

Sube esta carpeta a GitHub:
```bash
git add .
git commit -m "FlashBrowser para Render"
git push origin main
```

### 2. Deploy en Render

1. Ve a [render.com](https://render.com)
2. Conecta tu repositorio GitHub
3. Selecciona "Docker" como entorno
4. El Dockerfile se detectará automáticamente
5. ¡Despliego automático! 🚀

### 3. Conecta desde Android

- Descarga **TightVNC Viewer** 
- URL: `tu-servicio.onrender.com:5901`
- Contraseña: `123456`

---

## 🖥️ Ejecución Local (para pruebas)

### En Linux/WSL:

```bash
# Hacer script ejecutable
chmod +x start.sh

# Ejecutar
./start.sh

# Conectar VNC desde otra máquina
vncviewer localhost:5901
```

### En Windows (WSL2):

```bash
# Instalar WSL2 con Ubuntu
wsl --install -d Ubuntu

# Dentro de WSL:
cd /mnt/c/Users/Morit/Downloads/FlashBrowser-linux-x64
bash start.sh
```

---

## 📋 Requisitos Mínimos (Render)

- **Plan**: Starter ($7/mes) o Free Trial (30 días)
- **CPU**: 0.5 CPU
- **RAM**: 1 GB
- **Región**: Cualquiera (recomendado: cercana a ti)

---

## 🎮 El Juego

- **URL del juego**: https://www.mnfclub.com/game-windows.html
- **Abierto automáticamente** al iniciar FlashBrowser
- **Controles**: Mismo mouse/teclado de Android
- **Estado de sesión**: Se mantiene mientras el servidor esté activo

---

## ⚙️ Archivos Importantes

| Archivo | Descripción |
|---------|------------|
| `start.sh` | Script de inicialización para Linux |
| `Dockerfile` | Configuración del contenedor Docker |
| `render.yaml` | Configuración alternativa para Render |
| `DEPLOY_GUIDE.md` | Guía detallada de despliegue |
| `browser.html` | **MODIFICADO**: Abre https://www.mnfclub.com/game-windows.html |

---

## 🔐 Seguridad

⚠️ **Importante para producción:**

1. Cambiar contraseña VNC en `start.sh`:
   ```bash
   echo "TU_CONTRASEÑA_SEGURA" | vncpasswd -f > ~/.vnc/passwd
   ```

2. Usar HTTPS (Render lo proporciona)

3. Restringir acceso por IP (si es posible)

---

## 🐛 Solución de Problemas

### "No puedo conectar desde Android"
- Verifica que el servicio esté corriendo en Render Dashboard
- Revisa los logs: verás "Servidor VNC disponible en..."
- Comprueba tu conexión WiFi

### "El juego se ve lento"
- Reduce la resolución en `start.sh`: `-geometry 1024x576`
- Usa una conexión WiFi 5GHz
- Actualiza plan de Render a mejor CPU

### "FlashBrowser no inicia"
- Revisa logs en Render Dashboard
- Verifica que `browser.html` esté editado correctamente
- Prueba localmente con `bash start.sh`

---

## 📞 Soporte

Para más información:
- [Render Docs](https://render.com/docs)
- [Electron Docs](https://www.electronjs.org/docs)
- [TightVNC Manual](https://www.tightvnc.com/vncviewer.php)

---

## 📄 Licencia

Mantiene la licencia original de FlashBrowser/Chromium. Ver `LICENSE` y `LICENSES.chromium.html`.

---

**¡Listo para jugar! 🎉**
