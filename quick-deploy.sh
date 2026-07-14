#!/bin/bash
# Quick Deploy Script - FlashBrowser en Render
# Este script automatiza la preparación del repositorio para Render

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║    FlashBrowser - Preparación para Render.com         ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "FlashBrowser" ]; then
    echo "❌ Error: No se encuentra el ejecutable 'FlashBrowser'"
    echo "   Asegúrate de ejecutar este script desde la raíz de FlashBrowser"
    exit 1
fi

echo "✅ Verificación de archivos..."

# Verificar que existen los archivos necesarios
FILES=("start.sh" "Dockerfile" ".dockerignore" "README.md" "DEPLOY_GUIDE.md")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file"
    else
        echo "   ✗ FALTA: $file"
    fi
done

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║              PASOS SIGUIENTES                          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "1. PREPARAR GITHUB:"
echo "   $ git add ."
echo "   $ git commit -m 'FlashBrowser para Render'"
echo "   $ git push origin main"
echo ""

echo "2. IR A RENDER.COM:"
echo "   → Nueva Web Service"
echo "   → Conectar GitHub"
echo "   → Seleccionar este repositorio"
echo "   → Environment: Docker"
echo "   → Deploy"
echo ""

echo "3. CONECTAR DESDE ANDROID:"
echo "   → Descargar TightVNC Viewer"
echo "   → Address: tu-servicio.onrender.com"
echo "   → Port: 5901"
echo "   → Password: 123456"
echo ""

echo "╔════════════════════════════════════════════════════════╗"
echo "║  INFORMACIÓN DEL SERVIDOR                             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "🎮 Juego: https://www.mnfclub.com/game-windows.html"
echo "🖥️  Pantalla: 1280x720 (editable en start.sh)"
echo "🔐 VNC Password: 123456 (CAMBIAR para producción)"
echo "⏱️  Tiempo de despliegue: ~5-10 minutos"
echo ""

echo "📖 Lee DEPLOY_GUIDE.md para más información"
echo ""
echo "✨ ¡Listo! Ahora sube a GitHub y despliega en Render"
