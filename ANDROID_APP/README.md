# 📱 App Android - FlashGame

App React Native que conecta automáticamente al servidor VNC de FlashBrowser.

## ✨ Características

✅ Conexión automática al servidor  
✅ Interfaz moderna y responsiva  
✅ Sin necesidad de instalar cliente VNC adicional  
✅ Control completo del juego desde Android  
✅ Compatible con Android 6.0+  
✅ Pronto en Google Play Store  

---

## 🚀 Instalación Local (Desarrollo)

### Requisitos

```bash
# Node.js 16+
node --version

# Android Studio o línea de comandos
android --version

# Java Development Kit
java -version
```

### Setup

```bash
# 1. Instalar dependencias
npm install

# 2. Instalar Watchman (en macOS/Linux)
brew install watchman

# 3. Instalar Android SDK Tools
# (Viene con Android Studio)
```

---

## 🏃 Ejecutar en Emulador

```bash
# Terminal 1: Iniciar Metro Bundler
npm start

# Terminal 2: Ejecutar en Android
npm run android

# O en iOS (solo macOS)
npm run ios
```

---

## 📦 Build APK para Android

### Debug APK (para testing):

```bash
npm run build-android
```

El APK se generará en:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### Release APK (para Play Store):

```bash
npm run build-android-apk
```

El APK se generará en:
```
android/app/build/outputs/apk/release/app-release.apk
```

---

## 🔐 Configurar Servidor

Edita `App.js` y cambia estas líneas:

```javascript
const SERVER_HOST = 'tu-dominio-render.com'; // Tu servidor
const SERVER_PORT = 5901;
const SERVER_PASSWORD = '123456'; // Cambiar contraseña
const NOVNC_WEB_PORT = 6080;
```

---

## 🎯 Flujo de la App

```
Inicio App
    ↓
¿Conectado a servidor? (AsyncStorage)
    ├─ SÍ → Pantalla de Inicio
    └─ NO → Cargar configuración + conectar
    
Usuario toca "JUGAR AHORA"
    ↓
Abre navegador integrado
    ↓
Conecta a noVNC (sin instalar app extra)
    ↓
Usuario ve y controla el juego
```

---

## 📱 Instalar en Android (Sin Play Store)

### Método 1: Con Android Studio

```bash
# 1. Conecta tu Android via USB (modo desarrollador activado)
# 2. Ejecuta:
npm run android
```

### Método 2: Instalar APK directamente

```bash
# En Windows (con ADB instalado)
adb install android/app/build/outputs/apk/debug/app-debug.apk

# En Mac/Linux
./android-sdk/platform-tools/adb install android/app/build/outputs/apk/debug/app-debug.apk
```

### Método 3: Transferir APK por cable/email

1. Envía el APK por email o copia a tu Android
2. Abre el archivo desde el gestor de archivos
3. Android pedirá permiso de instalación
4. ¡Listo!

---

## 🔧 Estructura del Proyecto

```
ANDROID_APP/
├── App.js                 # Componente principal
├── app.json              # Configuración de la app
├── package.json          # Dependencias
├── android/              # Configuración Android
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   └── gradle.properties
├── assets/               # Iconos y recursos
│   ├── icon.png
│   └── splash.png
└── README.md            # Este archivo
```

---

## 📋 Archivos de Configuración

### android/app/build.gradle

```gradle
android {
    compileSdkVersion 33
    defaultConfig {
        applicationId "com.flashgame.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

### android/gradle.properties

```properties
FLIPPER_VERSION=0.182.0
org.gradle.jvmargs=-Xmx2048m
android.useAndroidX=true
android.enableJetifier=true
```

---

## 🚀 Deploy a Google Play Store

### 1. Generar keystore (solo primera vez)

```bash
# En Windows (PowerShell como Admin)
cd android/app
keytool -genkey -v -keystore ./release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias flashgame

# En Mac/Linux
keytool -genkey -v -keystore ./release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias flashgame
```

Responde las preguntas:
- **Contraseña**: Mínimo 6 caracteres (guarda en lugar seguro)
- **Nombre**: Flash Game
- **Compañía**: Tu nombre/compañía
- **País**: Tu país

### 2. Configurar Gradle

Edita `android/gradle.properties`:

```properties
FLASHGAME_STORE_FILE=./release.keystore
FLASHGAME_STORE_PASSWORD=tu_contraseña
FLASHGAME_KEY_ALIAS=flashgame
FLASHGAME_KEY_PASSWORD=tu_contraseña
```

### 3. Build Release APK

```bash
npm run build-android-apk
```

### 4. Upload a Google Play

1. Ve a [Google Play Console](https://play.google.com/console)
2. Crea nueva app
3. Carga el APK release
4. Rellena información:
   - Nombre: "Flash Game"
   - Descripción: "Juega Flash games en vivo desde servidor"
   - Screenshots: Captura de pantalla de conexión
   - Categoría: Juegos
5. Publica

---

## 🐛 Troubleshooting

### "Metro bundler error"

```bash
# Limpia caché
npm start -- --reset-cache
```

### "Cannot find Android SDK"

```bash
# Instala Android Studio desde:
# https://developer.android.com/studio

# O configura manual:
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools
```

### "Conexión rechazada en puerto 5901"

Verifica que:
1. El servidor Render esté activo
2. Cambiar `SERVER_HOST` en `App.js` con tu dominio real
3. Asegúrate de que noVNC esté corriendo en el servidor (puerto 6080)

---

## 📊 Monitoreo en Tiempo Real

### Ver logs de la app

```bash
adb logcat *:S ReactNative:V
```

### Simular conexión lenta

```bash
# En Android Studio Emulator
Extended controls → Network → Slow 3G
```

---

## 🔒 Seguridad

⚠️ **Importante para producción:**

1. **Cambiar contraseña VNC**: Edita `App.js` y `start.sh`
2. **HTTPS**: Usa certificados SSL en Render
3. **Firewall**: Restringe acceso VNC a IPs conocidas (si es posible)
4. **Rate Limiting**: Implementa límite de intentos de conexión

---

## 💾 Backup de Keystore

**IMPORTANTE**: Guarda el keystore en lugar seguro:

```bash
# Copia a carpeta segura
cp android/app/release.keystore ~/.ssh/flashgame-release.keystore
chmod 600 ~/.ssh/flashgame-release.keystore
```

Sin este archivo, no podrás actualizar la app en Play Store.

---

## 📞 Soporte

- **React Native Docs**: https://reactnative.dev/docs/getting-started
- **Android Studio Docs**: https://developer.android.com/studio/intro
- **Google Play Console**: https://play.google.com/console

---

## 📈 Versiones Futuras

- [ ] Soporte para múltiples servidores
- [ ] Guardado de favoritos
- [ ] Modo offline con grabación
- [ ] Modo multiplayer (múltiples usuarios)
- [ ] Chat integrado

---

**¡App lista para producción! 🚀**
