#!/usr/bin/env powershell
# Script para subir FlashBrowser a GitHub automáticamente

Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  FlashBrowser → GitHub Automático     ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Configuración
$RepoPath = "C:\Users\Morit\Downloads\FlashBrowser-linux-x64"
$GitHubURL = Read-Host "Ingresa tu URL de GitHub (ej: https://github.com/USUARIO/flashbrowser.git)"
$UserName = Read-Host "Tu nombre (para git commits)"
$UserEmail = Read-Host "Tu email (para git commits)"

Write-Host ""
Write-Host "📋 Configuración:" -ForegroundColor Cyan
Write-Host "Repo local: $RepoPath"
Write-Host "GitHub URL: $GitHubURL"
Write-Host "Usuario: $UserName"
Write-Host "Email: $UserEmail"
Write-Host ""

# Cambiar a directorio
cd $RepoPath
Write-Host "✓ Cambiado a: $RepoPath" -ForegroundColor Green

# Verificar si existe .git
if (Test-Path ".git") {
    Write-Host "⚠️  Git ya inicializado, limpiando..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
}

# Inicializar Git
Write-Host "🔧 Inicializando git..." -ForegroundColor Cyan
git init
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en git init. ¿Git no está instalado?" -ForegroundColor Red
    Write-Host "Descarga desde: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Git inicializado" -ForegroundColor Green

# Configurar usuario
Write-Host "🔧 Configurando usuario git..." -ForegroundColor Cyan
git config --global user.name "$UserName"
git config --global user.email "$UserEmail"
Write-Host "✓ Usuario configurado" -ForegroundColor Green

# Agregar archivos
Write-Host "📦 Agregando archivos..." -ForegroundColor Cyan
git add .
Write-Host "✓ Archivos agregados" -ForegroundColor Green

# Crear commit
Write-Host "📝 Creando commit..." -ForegroundColor Cyan
git commit -m "FlashBrowser + App Android - Render ready"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en commit" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Commit creado" -ForegroundColor Green

# Agregar remote
Write-Host "🔗 Conectando con GitHub..." -ForegroundColor Cyan
git remote add origin $GitHubURL
Write-Host "✓ Remote agregado" -ForegroundColor Green

# Cambiar rama a main
Write-Host "🎋 Cambiando rama a main..." -ForegroundColor Cyan
git branch -M main
Write-Host "✓ Rama cambiada" -ForegroundColor Green

# Push
Write-Host "📤 Subiendo a GitHub..." -ForegroundColor Cyan
Write-Host "(Te pedirá usuario/contraseña de GitHub)" -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  ✓ ¡ÉXITO! Código en GitHub          ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Próximo paso: Render" -ForegroundColor Cyan
    Write-Host "Ve a: https://render.com" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Error en push. Verifica tu conexión y credenciales" -ForegroundColor Red
    exit 1
}

Pause
