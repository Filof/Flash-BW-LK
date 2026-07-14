# 🧪 PRUEBA LOCAL EN WSL - Referencia Rápida

## Estado Actual ✅

**FlashBrowser está corriendo en WSL Ubuntu 22.04:**
- **VNC Server**: localhost:5901
- **Pantalla Virtual**: :99 (1280x720)
- **Navegador**: Abierto en https://www.mnfclub.com/game-windows.html
- **Contraseña VNC**: `123456`

---

## 📱 Conectar desde Windows

### Opción 1: Línea de Comandos (si tienes TightVNC instalado)

```powershell
vncviewer localhost:5901
# Contraseña: 123456
```

### Opción 2: Instalar TightVNC (si no lo tienes)

#### Con Chocolatey:
```powershell
# Como administrador
choco install tightvnc -y
```

#### Descargar manualmente:
1. Visita: https://www.tightvnc.com/download.php
2. Descarga "TightVNC Viewer for Windows"
3. Instala
4. Abre TightVNC Viewer
5. Conecta a: `localhost:5901`

#### Desde Microsoft Store:
1. Abre Microsoft Store
2. Busca "VNC"
3. Instala cualquier cliente VNC

### Opción 3: Usar RDP (Remote Desktop) - Windows nativo

```powershell
# En PowerShell
mstsc /v:localhost:3389
```

---

## 🎮 Qué Deberías Ver

1. Una ventana negra de FlashBrowser
2. La interfaz del navegador con barra de herramientas
3. El juego cargando en https://www.mnfclub.com/game-windows.html

**Nota**: La primera carga puede tardar 20-30 segundos (Chromium está renderizando).

---

## 🔧 Control Remoto (en la conexión VNC)

| Acción | Resultado |
|--------|-----------|
| **Click izquierdo** | Click normal |
| **Click derecho** | 2 clics con botón derecho |
| **Doble click** | Doble click |
| **Arrastrar** | Mantener y mover mouse |

---

## 📊 Monitoreo en Tiempo Real

**Desde otra PowerShell**, monitorea los procesos:

```powershell
# Ver logs en vivo
wsl -d Ubuntu-22.04 -u root bash -c "tail -f /var/log/Xvfb.log 2>/dev/null || echo 'Xvfb activo'"

# Ver procesos activos
wsl -d Ubuntu-22.04 -u root bash -c "ps aux | grep -E 'FlashBrowser|vncserver|Xvfb' | grep -v grep"

# Ver uso de CPU/RAM
wsl -d Ubuntu-22.04 -u root bash -c "top -b -n 1 | head -15"
```

---

## ⚠️ Si Algo Falla

### "Cannot connect to localhost:5901"

```powershell
# Verifica que VNC esté corriendo
wsl -d Ubuntu-22.04 -u root bash -c "ps aux | grep vncserver"

# Si no aparece, reinicia:
wsl -d Ubuntu-22.04 -u root bash -c "pkill -f vncserver; vncserver :1 -geometry 1280x720"
```

### "El navegador no se ve"

```powershell
# Comprueba que Xvfb esté corriendo
wsl -d Ubuntu-22.04 -u root bash -c "ps aux | grep Xvfb"

# Si falla, limpia y reinicia:
wsl -d Ubuntu-22.04 -u root bash -c "pkill -f Xvfb; rm -f /tmp/.X99-lock; Xvfb :99 -screen 0 1280x720x24 -ac &"
```

### "The command became idle" (WSL se desconecta)

El terminal WSL entró en modo background. Eso es normal. El servidor sigue corriendo:

```powershell
# Verifica que todo sigue activo
wsl -d Ubuntu-22.04 -u root bash -c "ps aux | grep FlashBrowser"
```

---

## 🚀 Una Vez Que Funcione Localmente

1. **Guardar cambios en GitHub** (todos los archivos están listos)
2. **Desplegar en Render.com** (mismo código que funciona acá)
3. **Conectar desde Android** usando TightVNC Viewer

---

## 📋 Troubleshooting Rápido

```powershell
# Script todo-en-uno para limpiar y reiniciar

wsl -d Ubuntu-22.04 -u root bash -c "
echo 'Limpiando procesos antiguos...'
pkill -f 'FlashBrowser|vncserver|Xvfb' || true
rm -f /tmp/.X*-lock

echo 'Reiniciando Xvfb...'
Xvfb :99 -screen 0 1280x720x24 -ac &
sleep 2

echo 'Iniciando VNC...'
vncserver :1 -geometry 1280x720 -depth 24 &
sleep 2

echo 'Iniciando FlashBrowser...'
cd /app/flashbrowser
export DISPLAY=:99
./FlashBrowser --no-sandbox --disable-gpu --disable-web-resources &

echo 'Listo! Conecta a localhost:5901'
"
```

---

## 📊 Info del Sistema

**WSL Setup Actual:**
- **Distribución**: Ubuntu 22.04
- **RAM asignada**: ~1-2 GB (depende de Windows)
- **CPU**: Compartida con Windows
- **Resolución**: 1280x720
- **Puerto VNC**: 5901
- **Pantalla Virtual**: :99

---

## 🎯 Próximos Pasos

✅ Localmente en WSL - **EN PROGRESO**
1. Conectar con VNC desde Windows
2. Verificar que el juego carga y funciona
3. Probar controles del navegador

⏳ En Render.com - **DESPUÉS**
1. Subir código a GitHub
2. Crear servicio en Render
3. Conectar desde Android

---

**¿Todo corriendo correctamente? ¡Procede a GitHub!** 🚀
