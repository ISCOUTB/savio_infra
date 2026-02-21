#!/bin/bash

# Script de configuración rápida para Savio Infra
# Este script automatiza todo el proceso de instalación

echo
echo "=== Configuración rápida de Savio Infra ==="
echo

# Detectar sistema operativo
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "🖥️  Sistema operativo detectado: $MACHINE"

# Verificar si estamos en bash
if [ -z "$BASH_VERSION" ]; then
    echo "❌ Este script requiere bash."
    if [ "$MACHINE" = "Windows" ]; then
        echo "   Por favor usa Git Bash en lugar de Command Prompt o PowerShell."
        echo "   Descarga Git desde: https://git-scm.com/download/win"
    fi
    exit 1
fi

echo "✅ Terminal bash detectado correctamente"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instálalo primero."
    echo "Visita: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar si Docker Compose está instalado y determinar el comando a usar
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
    echo "✅ Docker Compose (v2) detectado"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
    echo "✅ Docker Compose (v1) detectado"
else
    echo "❌ Docker Compose no está instalado. Por favor instálalo primero."
    exit 1
fi

# Descargar Moodle si no existe
if [ ! -d "moodle" ]; then
    echo "📥 Descargando Moodle..."
    bash bajar_moodle.sh
else
    echo "✅ Moodle ya está descargado"
fi

# Crear directorio para datos de Moodle si no existe
if [ ! -d "moodledata" ]; then
    echo "📁 Creando directorio moodledata..."
    mkdir -p moodledata
    chmod 777 moodledata
else
    echo "✅ Directorio moodledata ya existe"
fi

echo
echo "🚀 Levantando la infraestructura..."
$DOCKER_COMPOSE_CMD up -d

echo
echo "✅ ¡Configuración completa!"
echo
echo "📋 Información importante:"
echo "   - Moodle estará disponible en: http://localhost"
echo "   - Host DB: db"
echo "   - Nombre DB: alpydb"
echo "   - Usuario DB: alpyuser"
echo "   - Contraseña DB: alpypass" 

echo
echo "🔧 Para detener los servicios: $DOCKER_COMPOSE_CMD down"
echo "📖 Lee el README.md para más información"
