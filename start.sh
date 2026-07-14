#!/bin/bash

# Script de inicio para FlashBrowser en Render (Linux sin GUI)
# Este script configura el entorno necesario y ejecuta el navegador

set -e

echo "=========================================="
echo "FlashBrowser - Inicializando en Linux"
echo "=========================================="

# Actualizar e instalar dependencias necesarias
echo "[1/5] Instalando dependencias del sistema..."
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
  2>/dev/null || true

# Crear pantalla virtual Xvfb
echo "[2/5] Creando pantalla virtual X11..."
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 -ac &
XVFB_PID=$!
sleep 3

# Iniciar VNC Server para acceso remoto desde Android
echo "[3/5] Iniciando servidor VNC..."
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
vncserver :1 -geometry 1280x720 -depth 24 -name "FlashGame" 2>/dev/null &
VNC_PID=$!
sleep 2

# Preparar FlashBrowser
echo "[4/5] Preparando FlashBrowser..."
cd "$(dirname "$0")"
chmod +x FlashBrowser

# Configurar variables de entorno para Chromium sin GPU
export LIBGL_ALWAYS_INDIRECT=1
export QT_QPA_PLATFORM=offscreen

# Variables adicionales para mejor compatibilidad
export GDK_SCALE=1
export GDK_DPI_SCALE=1

# Ejecutar FlashBrowser
echo "[5/5] Iniciando FlashBrowser..."
echo "=========================================="
echo "Servidor VNC disponible en: localhost:5901"
echo "Conexión remota: [dominio]:5901"
echo "URL del juego: https://www.mnfclub.com/game-windows.html"
echo "=========================================="

# Ejecutar el navegador con flags necesarios para root
./FlashBrowser --no-sandbox --disable-gpu --disable-web-resources

# Mantener los servicios activos
wait $XVFB_PID $VNC_PID
