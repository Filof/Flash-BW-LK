# 🎯 Guía Rápida: App Android

## ⚡ Plan Rápido (1-2 horas)

### 1. Descargar Android Studio
```
https://developer.android.com/studio
↓
Instala (selecciona Android SDK)
```

### 2. Setup App

```bash
cd ANDROID_APP
npm install
```

### 3. Cambiar Servidor

Edita `App.js` línea ~30:

```javascript
const SERVER_HOST = 'tu-dominio.onrender.com'; // Tu servidor
```

### 4. Ejecutar en Emulador

```bash
# Terminal 1
npm start

# Terminal 2
npm run android
```

¡Verás la app funcionando! 🎉

---

## 📦 Para Publicar en Play Store

### 1. Crear Keystore (firma)

```bash
cd ANDROID_APP/android/app
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias flashgame
```

Contraseña: `Elige una segura` (guarda en lugar seguro)

### 2. Build Release

```bash
cd ..
npm run build-android-apk
```

APK en: `android/app/build/outputs/apk/release/app-release.apk`

### 3. Subir a Play Store

1. Ve a: https://play.google.com/console
2. Crea cuenta ($25 USD)
3. Crea app
4. Sube APK
5. Rellena info (descripción, screenshots)
6. Publica

**Aprobación**: 2-24 horas

---

## 🔧 Configuración Avanzada

Ver: [ANDROID_APP_SETUP.md](ANDROID_APP_SETUP.md)

---

## 📱 Arquivos de la App

```
ANDROID_APP/
├── App.js           # UI y conexión VNC
├── app.json         # Metadata
├── package.json     # Dependencias
├── android/         # Config Android (gradle)
└── README.md        # Docs completa
```

---

## ❓ Troubleshooting Rápido

| Problema | Solución |
|----------|----------|
| **"No conecta"** | Verifica `SERVER_HOST` en App.js |
| **"Metro bundler error"** | `npm start -- --reset-cache` |
| **"No encuentra Android SDK"** | Instala Android Studio |
| **"APK muy grande"** | Es normal (~100MB), Chromium incluido |

---

## 🎮 Ya en Producción

Una vez publicada:

```bash
# Para actualizar
1. Cambia versionCode en app.json
2. npm run build-android-apk
3. Sube a Play Console
4. Google Play lo publica en 2-3 horas
```

---

**¿Necesitas algo más detallado? Ver ANDROID_APP_SETUP.md** 📖
