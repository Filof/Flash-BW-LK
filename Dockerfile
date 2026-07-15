# Dockerfile para FlashBrowser en Render
FROM ubuntu:20.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
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
    curl \
    wget \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libxkbcommon0 \
    lsb-base \
    && rm -rf /var/lib/apt/lists/*

# Copiar FlashBrowser
WORKDIR /app
COPY . .

# Hacer ejecutables los scripts
RUN chmod +x /app/FlashBrowser-linux-x64/FlashBrowser && \
    chmod +x /app/start.sh

# Crear directorio para VNC
RUN mkdir -p /root/.vnc

# Variables de entorno
ENV DISPLAY=:99 \
    LIBGL_ALWAYS_INDIRECT=1 \
    QT_QPA_PLATFORM=offscreen \
    PORT=5901

# Exponer puerto VNC
EXPOSE 5901

# Ejecutar script de inicio
CMD ["./start.sh"]
