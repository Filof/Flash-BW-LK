@echo off
REM Script para conectar a FlashBrowser en WSL via VNC desde Windows

title FlashBrowser VNC Client
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║   FlashBrowser - Conexión VNC desde Windows               ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Verificar si TightVNC está instalado
where vncviewer >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ TightVNC Viewer encontrado
    echo.
    echo Conectando a localhost:5901...
    echo Contraseña: 123456
    echo.
    vncviewer localhost:5901
) else (
    echo.
    echo ❌ TightVNC Viewer no encontrado
    echo.
    echo Opciones de instalación:
    echo.
    echo 1. Instalar con Chocolatey:
    echo    choco install tightvnc -y
    echo.
    echo 2. Descargar manualmente:
    echo    https://www.tightvnc.com/download.php
    echo.
    echo 3. Instalar desde Microsoft Store:
    echo    https://www.microsoft.com/en-us/search/shop/apps?q=vnc
    echo.
    pause
)
