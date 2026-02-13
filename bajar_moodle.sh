#!/bin/bash

# Script para descargar y extraer Moodle con selección de versión

# Verificar si estamos en bash
if [ -z "$BASH_VERSION" ]; then
    echo "❌ Este script requiere bash."
    echo "   Windows: Usa Git Bash (no Command Prompt o PowerShell)"
    echo "   Linux/macOS: Usa el terminal nativo"
    exit 1
fi

echo "=== Selector de versión de Moodle ==="
echo
echo "Selecciona la versión de Moodle que deseas descargar:"
echo "1) Moodle 4.1.13 (LTS - Estable a largo plazo)"
echo "2) Moodle 4.5.2 (Estable)"
echo "3) Moodle 5.0+ (Última versión disponible)"
echo

read -p "Ingresa tu opción (1-3): " opcion

case $opcion in
    1)
        VERSION="4.1.13"
        URL="https://download.moodle.org/download.php/direct/stable401/moodle-4.1.13.tgz"
        FILENAME="moodle-4.1.13.tgz"
        echo "Has seleccionado Moodle 4.1.13 (LTS)"
        ;;
    2)
        VERSION="4.5.2"
        URL="https://download.moodle.org/download.php/direct/stable405/moodle-4.5.2.tgz"
        FILENAME="moodle-4.5.2.tgz"
        echo "Has seleccionado Moodle 4.5.2"
        ;;
    3)
        VERSION="5.0+"
        URL="https://download.moodle.org/download.php/direct/stable50/moodle-latest.tgz"
        FILENAME="moodle-latest.tgz"
        echo "Has seleccionado Moodle 5.0+ (última versión)"
        ;;
    *)
        echo "❌ Opción inválida. Por favor ejecuta el script nuevamente."
        exit 1
        ;;
esac

echo
echo "📥 Descargando Moodle $VERSION..."

# Verificar si ya existe una instalación de Moodle
if [ -d "moodle" ]; then
    echo "⚠️  Ya existe una carpeta 'moodle'. ¿Deseas reemplazarla?"
    read -p "Escribe 'si' para continuar o cualquier otra cosa para cancelar: " confirmar
    if [ "$confirmar" != "si" ]; then
        echo "❌ Operación cancelada."
        exit 1
    fi
    echo "🗑️  Eliminando instalación anterior..."
    rm -rf moodle
fi

# Descargar Moodle
if command -v curl &> /dev/null; then
    echo "📡 Usando curl para descargar..."
    # -L sigue redirecciones, indispensable para sourceforge/moodle.org
    curl -L "$URL" -o "$FILENAME"
elif command -v wget &> /dev/null; then
    echo "📡 Usando wget para descargar..."
    wget "$URL" -O "$FILENAME"
else
    echo "❌ No se encontró curl ni wget. Por favor instala uno de ellos."
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "❌ Error al descargar Moodle. Verifica tu conexión a internet."
    exit 1
fi

echo "📦 Extrayendo Moodle..."
tar -xzf "$FILENAME"

if [ $? -ne 0 ]; then
    echo "❌ Error al extraer Moodle."
    exit 1
fi

echo "🧹 Limpiando archivos temporales..."
rm "$FILENAME"

echo
echo "✅ ¡Moodle $VERSION descargado y extraído exitosamente!"
echo "📁 El código fuente está en la carpeta 'moodle/'"
echo "🚀 Ahora puedes ejecutar: docker compose up"
