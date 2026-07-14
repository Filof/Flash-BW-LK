# 🎮 Guía Completa: App Android + FlashBrowser

## 📋 Contenido

1. [Arquitectura](#arquitectura)
2. [Setup Servidor (Render)](#setup-servidor)
3. [Build App Android](#build-app-android)
4. [Deploy Play Store](#deploy-play-store)
5. [Troubleshooting](#troubleshooting)

---

## Arquitectura

```
┌─────────────────────────────────────┐
│   USUARIO EN ANDROID                │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  App "Flash Game"             │  │
│  │  (React Native)               │  │
│  └──────────┬───────────────────┘  │
└─────────────┼──────────────────────┘
              │
              │ TCP 5901 (VNC Protocol)
              │ o HTTP 6080 (noVNC Web)
              │
┌─────────────▼──────────────────────┐
│   SERVIDOR EN RENDER (Linux)        │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  FlashBrowser (Electron)      │  │
│  │  Ejecuta juego Flash          │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│  ┌──────────▼───────────────────┐  │
│  │  Xvfb (Pantalla Virtual :99)  │  │
│  │  Renderiza gráficos           │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│  ┌──────────▼───────────────────┐  │
│  │  VNC Server (puerto 5901)     │  │
│  │  TightVNC Server              │  │
│  └──────────┬───────────────────┘  │
│             │                       │
│  ┌──────────▼───────────────────┐  │
│  │  noVNC Web (puerto 6080)      │  │
│  │  WebSocket bridge             │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

## Setup Servidor

### 1. En Render.com

Usa el Dockerfile mejorado: `Dockerfile.app`

```yaml
# render.yaml
services:
  - type: web
    name: flashbrowser-game
    env: docker
    region: ohio
    dockerfile: Dockerfile.app
    startCommand: bash /app/start-with-app.sh
    envVars:
      - key: DISPLAY
        value: ":99"
      - key: LIBGL_ALWAYS_INDIRECT
        value: "1"
    ports:
      - port: 5901
        protocol: tcp
      - port: 6080
        protocol: http
```

### 2. Puertos Expuestos

| Puerto | Protocolo | Uso |
|--------|-----------|-----|
| 5901 | TCP (VNC) | Acceso VNC nativo |
| 6080 | HTTP | noVNC (web) |

### 3. URL de Acceso

Una vez desplegado en Render:

- **VNC Client**: `flashbrowser-xyz.onrender.com:5901`
- **Web Browser**: `https://flashbrowser-xyz.onrender.com:6080`
- **App Android**: `flashbrowser-xyz.onrender.com:5901`

---

## Build App Android

### Requisitos

```bash
# Node.js 16+ 
node -v

# Java 11+
java -version

# Android SDK (descarga Android Studio)
```

### Paso 1: Instalar Dependencias

```bash
cd ANDROID_APP
npm install
```

### Paso 2: Configurar Servidor

Edita `App.js`:

```javascript
const SERVER_HOST = 'flashbrowser-xyz.onrender.com'; // Tu servidor
const SERVER_PASSWORD = '123456'; // Cambia la contraseña
```

### Paso 3: Build Debug

```bash
npm run android
```

Esto:
1. Compila la app
2. La instala en emulador/dispositivo conectado
3. La abre automáticamente

### Paso 4: Generar Release APK

```bash
npm run build-android-apk
```

APK generado en:
```
ANDROID_APP/android/app/build/outputs/apk/release/app-release.apk
```

---

## Deploy Play Store

### 1. Crear Cuenta Google Play Developer

```
https://play.google.com/console
├─ Crear cuenta
├─ Pagar $25 USD (única vez)
└─ Activada al instante
```

### 2. Generar Firma (Keystore)

**Solo la primera vez:**

```bash
cd ANDROID_APP/android/app

# Windows
keytool -genkey -v -keystore release.keystore ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias flashgame

# Mac/Linux
keytool -genkey -v -keystore release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias flashgame
```

Datos a ingresar:
```
First and last name: Flash Game
Organizational unit: Gaming
Organization: Your Company
City: Your City
State/Province: Your State
Country code: US
Password: TuContraseña123 (MIN 6 caracteres - GUARDAR EN LUGAR SEGURO!)
```

### 3. Configurar build.gradle

Edita `ANDROID_APP/android/app/build.gradle`:

```gradle
android {
    signingConfigs {
        release {
            storeFile file('release.keystore')
            storePassword 'TuContraseña123'
            keyAlias 'flashgame'
            keyPassword 'TuContraseña123'
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'),
                'proguard-rules.pro'
        }
    }
}
```

### 4. Build Release APK

```bash
npm run build-android-apk
```

### 5. Crear App en Play Console

1. Abre: https://play.google.com/console
2. **Create app**
   - Nombre: "Flash Game"
   - Categoría: Juegos
   - Tipo: Juego
3. Rellena formulario de consentimiento
4. Ir a "Release" → "Production"
5. Sube el APK release

### 6. Información de App (Play Listing)

Complete:
- **Icono**: 512x512 PNG
- **Pantalla principal**: 1080x1920 JPG
- **Screenshots**: Mínimo 2 (1080x1920)
- **Descripción breve**: "Juega Flash games en vivo"
- **Descripción completa**: 
  ```
  Flash Game es un cliente remoto que te permite jugar 
  juegos Flash en vivo desde un servidor en la nube.
  
  Características:
  ✓ Juegos Flash en tiempo real
  ✓ Baja latencia
  ✓ Conexión segura
  ✓ Compatible con todos los juegos Flash
  ```
- **Categoría**: Juegos → Casual
- **Clasificación**: ¿Contiene contenido para adultos?

### 7. Información de Contenido

- **Edad**: 3+ (o según tu juego)
- **Categoría de contenido**: Casual

### 8. Fijación de Precio

- **Gratis**
- **Disponible en todos los países**

### 9. Publicar

1. Sube el APK release
2. Revisa las políticas de Google Play
3. Click en **Publish**

**Tiempo de aprobación**: 1-24 horas (usualmente 2-3 horas)

---

## Troubleshooting

### "App no conecta al servidor"

```bash
# Verifica que Render esté corriendo
curl -v https://flashbrowser-xyz.onrender.com:6080

# Revisa logs en Render Dashboard
```

### "Build fails - No Android SDK"

```bash
# Instala Android Studio
# https://developer.android.com/studio

# O configura variables
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Instala SDK tools
sdkmanager "platform-tools" "platforms;android-33"
```

### "APK muy grande (>100MB)"

El tamaño es normal (Chromium incluido). Render lo maneja.

### "Play Store rechaza el APK"

Causas comunes:
- Contraseña débil en firmas
- API key incorrecta
- Screenshots no cumplen especificaciones
- Contenido no permitido

---

## 📊 Monitoreo Post-Publicación

### Analytics en Play Console

```
Play Console → Estadísticas
├─ Instalaciones
├─ Usuarios activos
├─ Crashes
├─ Reviews
└─ Descargas
```

### Actualizar App

```bash
# Aumenta versionCode en app.json
{
  "versionCode": 2,
  "versionName": "1.0.1"
}

# Build nuevo
npm run build-android-apk

# Upload a Play Console
# (automático si usas Play Console API)
```

---

## 🔒 Seguridad

### Antes de Publicar

- [ ] Cambiar contraseña VNC en `App.js`
- [ ] Usar HTTPS en Render (automático)
- [ ] No incluir credenciales en código
- [ ] Activar firma de código
- [ ] Probar en múltiples dispositivos

### Post-Publicación

- [ ] Monitorear crashes en Play Console
- [ ] Responder reviews
- [ ] Actualizar regularmente
- [ ] Revisar logs de servidor

---

## 📈 Métricas Esperadas

- **Instalaciones/día**: 10-100 (depende de marketing)
- **Uninstall rate**: <5% es bueno
- **Rating**: Apunta a 4.0+ estrellas
- **Crash rate**: <0.5%

---

## 💡 Tips Avanzados

### 1. Versiones Beta

Antes de publicar:

```bash
# En Play Console
Release → Internal testing
├─ Sube APK
├─ Genera link de testing
└─ Comparte con grupo de testers
```

### 2. A/B Testing

Prueba diferentes descripciones:

```
Play Console → Estrategia → Experimento A/B
├─ Icono
├─ Captura de pantalla
└─ Descripción
```

### 3. Comentarios/Reviews

```
Play Console → Reviews
├─ Responde críticas negativas
├─ Agradece comentarios positivos
└─ Usa feedback para mejoras
```

---

## 📞 Recursos

- [Google Play Developer Docs](https://developer.android.com/docs)
- [React Native Docs](https://reactnative.dev/docs/getting-started)
- [Android Studio Setup](https://developer.android.com/studio)
- [Play Console Help](https://support.google.com/googleplay)

---

**¡Tu app está lista para publicar! 🚀**
