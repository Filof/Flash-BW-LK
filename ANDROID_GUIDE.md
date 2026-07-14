# 📱 Conexión Android - Referencia Rápida

## 🔗 Datos de Conexión

**Una vez que el servidor esté activo en Render.com:**

| Parámetro | Valor |
|-----------|-------|
| **Address** | `tu-servicio.onrender.com` |
| **Port** | `5901` |
| **Password** | `123456` |
| **Username** | (dejar vacío) |

> ⚠️ Reemplaza `tu-servicio` con el nombre real de tu servicio en Render

## 📥 Apps Recomendadas para Android

1. **TightVNC Viewer** (Recomendado)
   - Play Store: https://play.google.com/store/apps/details?id=com.realvnc.viewer.android
   - Protocolo: VNC
   - Rendimiento: Excelente

2. **RealVNC Viewer**
   - Play Store: https://play.google.com/store/apps/details?id=com.realvnc.viewer.android
   - Protocolo: VNC
   - Mas funciones

3. **Chrome Remote Desktop**
   - Alternativa si no funciona VNC
   - Requiere configuración adicional

## 🚀 Pasos de Conexión (TightVNC)

### Primer Acceso:

1. Abre **TightVNC Viewer**
2. Toca **"+"** (nueva conexión)
3. Rellena:
   - **Connection name**: `FlashBrowser`
   - **Address**: `tu-servicio.onrender.com:5901`
   - **Password**: `123456`
4. Guarda
5. Toca el nuevo perfil para conectar

### Conexiones Posteriores:

- Solo abre TightVNC
- Selecciona tu conexión guardada
- ¡Listo!

## ⚙️ Configuración Recomendada

En TightVNC, después de conectar:

1. **Menú** → **Preferences**
   - **Picture Quality**: `Medium` (balance velocidad/calidad)
   - **Mouse Button Mapping**: Mantener por defecto
   - **Keyboard**: Autodetectar

2. **Controles en Pantalla**:
   - 2 dedos = clic derecho
   - Zoom = pellizcar
   - Pan = arrastrar con 2 dedos

## 🎮 Controlar el Juego

- **Click izquierdo**: Toque normal
- **Click derecho**: 2 dedos simultáneamente
- **Doble click**: Toque doble rápido
- **Arrastrar**: Mantener presionado y mover
- **Teclado**: Botón de teclado en la app

## 🔧 Solución de Problemas

### No puedo conectar

```
❌ "Connection refused" o "Connection timeout"

✅ Soluciones:
  1. Verifica que Render esté activo (Dashboard → Running)
  2. Espera 5 minutos después del deploy
  3. Revisa logs en Render
  4. Reinicia el servicio en Render Dashboard
```

### Pantalla negra o congelada

```
❌ La pantalla no se actualiza

✅ Soluciones:
  1. Desconecta y vuelve a conectar
  2. En TightVNC: Menú → Refresh
  3. Reduce la calidad (Picture Quality → Low)
  4. Aumenta RAM del servidor en Render
```

### Muy lento

```
❌ Mucha latencia (>500ms)

✅ Soluciones:
  1. Usa WiFi 5GHz en lugar de 2.4GHz
  2. Acércate al router
  3. Reduce resolución en start.sh (-geometry 1024x576)
  4. Cambia Region en Render a más cercana
  5. Actualiza plan de Render (mejor CPU)
```

### No se ve el juego

```
❌ "FlashBrowser opened but nothing loads"

✅ Soluciones:
  1. Espera 20 segundos (carga inicial lenta)
  2. Revisa que browser.html esté modificado
  3. Verifica logs: "navegando a URL..."
  4. Comprueba conexión a internet en Render
```

## 📊 Información Útil

**Puertos alternativos** (si 5901 no funciona):
- VNC servidor corre en `:1` (5901)
- Xvfb (pantalla virtual) en `:99` (no accesible)

**Pantalla compartida**:
- Resolución: 1280x720 (editable)
- Profundidad color: 24-bit (millones de colores)
- Refresco: ~30 FPS (depende de red)

**Sesión persistente**:
- Mientras Render esté corriendo, tu sesión permanece
- Cierra TightVNC sin problema, puedes reconectar
- El juego sigue corriendo en el servidor

## 💡 Tips y Trucos

1. **Guardar contraseña**: TightVNC lo hace automáticamente
2. **Acelerar conexión**: Usa la misma red WiFi que Render
3. **Múltiples Android**: Varios dispositivos pueden conectar simultáneamente
4. **Pantalla completa**: Botón en TightVNC para maximizar
5. **Cambiar resolución**: Solo edita start.sh y redeploy en Render

## 🔐 Seguridad

- **NO dejes contraseña como `123456` en producción**
- **Cambia en start.sh** línea: `echo "TU_CONTRASEÑA" | vncpasswd...`
- **Redeploy** en Render después de cambiar

## 📞 Si Nada Funciona

1. Verifica URL en Render Dashboard
2. Comprueba que el servicio está "Running"
3. Revisa los logs en Render (botón "Logs")
4. Reinicia servicio (botón "Restart")
5. Redeploy manual si es necesario

---

**¡Disfruta tu juego! 🎮**
