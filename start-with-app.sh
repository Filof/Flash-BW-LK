#!/bin/bash

# Script mejorado para FlashBrowser con soporte para noVNC
# Permite acceso desde navegador web (sin instalar VNC client)

set -e

cd "$(dirname "$0")"

echo "=========================================="
echo "FlashBrowser - Inicializando en Linux"
echo "Con soporte para app Android (noVNC)"
echo "=========================================="

# Actualizar e instalar dependencias necesarias
echo "[1/6] Instalando dependencias del sistema..."
apt-get update -qq 2>/dev/null || true
apt-get install -y \
  xvfb \
  x11-utils \
  libgconf-2-4 \
  libnotify4 \
  libgbm1 \
  libxss1 \
  libasound2 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libxrender1 \
  libxinerama1 \
  libxi6 \
  libxtst6 \
  tightvncserver \
  websockify \
  2>/dev/null || true

# Si el binario FlashBrowser no está presente, intentar obtenerlo vía Git LFS
if [ ! -f "./FlashBrowser-linux-x64/FlashBrowser" ]; then
  echo "[1.5/6] FlashBrowser no encontrado: intentando git lfs pull..."
  apt-get update -qq 2>/dev/null || true
  apt-get install -y git curl gnupg ca-certificates 2>/dev/null || true
  # Instalar git-lfs si hace falta
  if ! command -v git-lfs >/dev/null 2>&1; then
    echo "Instalando git-lfs..."
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash 2>/dev/null || true
    apt-get update -qq 2>/dev/null || true
    apt-get install -y git-lfs 2>/dev/null || true
    git lfs install || true
  fi
  # Intentar pull (puede fallar si no hay .git en el contexto)
  git lfs pull --include="FlashBrowser-linux-x64/FlashBrowser" || true
fi

# Verificar que el binario exista después del intento de descarga
if [ ! -f "./FlashBrowser-linux-x64/FlashBrowser" ]; then
  echo "ERROR: FlashBrowser no encontrado en ./FlashBrowser-linux-x64/FlashBrowser"
  echo "Asegúrate de que el binario esté presente o que Git LFS esté disponible en el contexto de build/run."
  exit 1
fi

# Crear pantalla virtual Xvfb
echo "[2/6] Creando pantalla virtual X11..."
export DISPLAY=:99
if [ -e /tmp/.X99-lock ] && ! pgrep -f "Xvfb :99" >/dev/null 2>&1; then
  echo "Limpiando lock stale de Xvfb en display 99..."
  rm -f /tmp/.X99-lock /tmp/.X11-unix/X99 2>/dev/null || true
fi
if pgrep -f "Xvfb :99" >/dev/null 2>&1; then
  echo "Xvfb :99 ya está en ejecución. Usando el servidor existente."
  XVFB_PID=$(pgrep -f "Xvfb :99" | head -n 1)
else
  Xvfb :99 -screen 0 1280x720x24 -ac &
  XVFB_PID=$!
fi
sleep 3

# Iniciar VNC Server para acceso VNC nativo
echo "[3/6] Iniciando servidor VNC nativo..."
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
vncserver :1 -geometry 1280x720 -depth 24 -name "FlashGame" 2>/dev/null &
VNC_PID=$!
sleep 2

# Iniciar noVNC - Acceso web (para app Android)
echo "[4/6] Iniciando noVNC (acceso web)..."
# Si websockify/novnc está disponible
if command -v websockify &> /dev/null || [ -d "/usr/share/novnc" ]; then
  websockify --web=/usr/share/novnc 6080 localhost:5901 2>/dev/null &
  NOVNC_PID=$!
  sleep 2
  echo "✓ noVNC disponible en puerto 6080"
else
  echo "⚠ noVNC no disponible (opcional)"
fi

# Preparar FlashBrowser
echo "[5/6] Preparando FlashBrowser..."
cd "$(dirname "$0")"
chmod +x FlashBrowser-linux-x64/FlashBrowser

# Verificar si el archivo es un puntero Git LFS en lugar de un binario real
if head -n 1 FlashBrowser-linux-x64/FlashBrowser | grep -q '^version https://git-lfs.github.com/spec/v1'; then
  echo "WARN: FlashBrowser es un puntero Git LFS, no el binario real."
  echo "Intentando obtener el binario desde Google Drive si está configurado..."

  # Función para extraer el ID desde una URL pública de Drive
  extract_file_id() {
    url="$1"
    # patrones comunes
    echo "$url" | sed -n 's#.*?/d/\([^/\?]*\).*#\1#p; s#.*[?&]id=\([^&]*\).*#\1#p'
  }

  # Descargar desde Google Drive manejando confirm tokens para archivos grandes
  download_from_gdrive() {
    file_id="$1"
    dest="$2"
    echo "Descargando desde Drive: $file_id -> $dest"
    cookie=/tmp/gdrive_cookie_$$.txt
    tmp_html=/tmp/gdrive_confirm_$$.html

    # Obtener la primera respuesta que puede contener el token de confirmación
    curl -s -c "$cookie" -L "https://drive.google.com/uc?export=download&id=${file_id}" -o "$tmp_html"
    # Buscar token
    confirm=$(grep -oP "confirm=\K[0-9A-Za-z_-]+" "$tmp_html" | head -n1 || true)
    if [ -n "$confirm" ]; then
      curl -s -Lb "$cookie" -L "https://drive.google.com/uc?export=download&confirm=${confirm}&id=${file_id}" -o "$dest"
    else
      # Intento directo
      curl -s -Lb "$cookie" -L "https://drive.google.com/uc?export=download&id=${file_id}" -o "$dest"
    fi
    rm -f "$cookie" "$tmp_html" 2>/dev/null || true
  }

  # Si se proporcionó GDRIVE_URL o GDRIVE_FILE_ID, intentar descarga
  if [ -n "$GDRIVE_FILE_ID" ] || [ -n "$GDRIVE_URL" ]; then
    if [ -z "$GDRIVE_FILE_ID" ] && [ -n "$GDRIVE_URL" ]; then
      GDRIVE_FILE_ID=$(extract_file_id "$GDRIVE_URL")
    fi
    if [ -n "$GDRIVE_FILE_ID" ]; then
      mkdir -p FlashBrowser-linux-x64
      download_from_gdrive "$GDRIVE_FILE_ID" "FlashBrowser-linux-x64/Flashbrowser.tmp" || true
      # Si la descarga tuvo éxito, reemplazar el archivo puntero
      if [ -s "FlashBrowser-linux-x64/Flashbrowser.tmp" ]; then
        mv "FlashBrowser-linux-x64/Flashbrowser.tmp" "FlashBrowser-linux-x64/Flashbrowser"
        mv "FlashBrowser-linux-x64/Flashbrowser" "FlashBrowser-linux-x64/FlashBrowser" || true
        chmod +x "FlashBrowser-linux-x64/FlashBrowser" || true
      else
        echo "ERROR: la descarga desde Drive falló o el archivo está vacío."
      fi
    else
      echo "ERROR: no se pudo determinar GDRIVE_FILE_ID desde GDRIVE_URL."
    fi
  else
    echo "No se configuró GDRIVE_FILE_ID ni GDRIVE_URL para descargar el binario desde Drive."
  fi

  # Verificar de nuevo
  if [ ! -f "./FlashBrowser-linux-x64/FlashBrowser" ] || head -n 1 FlashBrowser-linux-x64/FlashBrowser | grep -q '^version https://git-lfs.github.com/spec/v1'; then
    echo "ERROR: FlashBrowser sigue sin estar disponible como binario real."
    echo "Asegúrate de establecer la variable de entorno GDRIVE_FILE_ID o GDRIVE_URL en Railway con el ID/URL del archivo 'FlashBrowser' en Drive."
    exit 1
  fi
fi

# Configurar variables de entorno para Chromium sin GPU
export LIBGL_ALWAYS_INDIRECT=1
export QT_QPA_PLATFORM=offscreen
export GDK_SCALE=1
export GDK_DPI_SCALE=1

# Ejecutar FlashBrowser
echo "[6/6] Iniciando FlashBrowser..."
echo "=========================================="
echo "✓ Servidor VNC: localhost:5901"
echo "✓ Web (noVNC): localhost:6080"
echo "✓ App Android: Conecta a localhost:5901"
echo "URL del juego: https://www.mnfclub.com/game-windows.html"
echo "=========================================="

# Ejecutar el navegador con flags necesarios
./FlashBrowser-linux-x64/FlashBrowser \
  --no-sandbox \
  --disable-gpu \
  --disable-web-resources \
  --disable-dev-shm-usage \
  --process-per-site \
  --renderer-process-limit=1 \
  --disable-background-networking \
  --disable-background-timer-throttling \
  --disable-client-side-phishing-detection \
  --disable-default-apps \
  --disable-extensions \
  --disable-sync \
  --disable-translate \
  --no-first-run \
  --no-default-browser-check

# Mantener los servicios activos
wait $XVFB_PID $VNC_PID $NOVNC_PID 2>/dev/null || wait
