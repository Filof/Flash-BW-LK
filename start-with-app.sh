#!/bin/bash

# Script mejorado para FlashBrowser con soporte para noVNC
# Permite acceso desde navegador web (sin instalar VNC client)

set -e

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

# Crear pantalla virtual Xvfb
echo "[2/6] Creando pantalla virtual X11..."
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 -ac &
XVFB_PID=$!
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
chmod +x FlashBrowser

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
./FlashBrowser --no-sandbox --disable-gpu --disable-web-resources

# Mantener los servicios activos
wait $XVFB_PID $VNC_PID $NOVNC_PID 2>/dev/null || wait
