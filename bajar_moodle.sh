#!/bin/bash

# Script para descargar y extraer Moodle con detección dinámica de versiones

# Verificar si estamos en bash
if [ -z "$BASH_VERSION" ]; then
    echo "❌ Este script requiere bash."
    echo "   Windows: Usa Git Bash (no Command Prompt o PowerShell)"
    echo "   Linux/macOS: Usa el terminal nativo"
    exit 1
fi

echo "🔍 Buscando versiones disponibles de Moodle..."

# Obtener las ramas estables desde la 4.1 en adelante
BRANCHES=$(git ls-remote --heads https://github.com/moodle/moodle.git | awk -F'/' '/MOODLE_.*_STABLE/ {print $3}' | sed 's/MOODLE_//;s/_STABLE//' | grep -E '^[0-9]+$' | sort -V | awk '$1 >= 401')

if [ -z "$BRANCHES" ]; then
    echo "❌ Error al conectar con GitHub para obtener las versiones dinámicamente."
    echo "⚠️ Por favor verifica tu conexión a internet o asegúrate de tener git instalado."
    exit 1
fi

echo
echo "=== Selector dinámico de versión de Moodle ==="
echo

# Inicializar arrays compatibles con Bash 3.2 (macOS)
nombres=()
urls=()
archivos=()

idx=0
counter=1

# Añadir las ramas detectadas dinámicamente
for branch in $BRANCHES; do
    major=${branch:0:1}
    minor=${branch:1:2}
    
    # Manejar versiones como 39 (3.9)
    if [ ${#branch} -eq 2 ]; then
        major=${branch:0:1}
        minor=${branch:1:1}
    fi
    
    # Remover ceros a la izquierda
    minor=$((10#$minor))

    etiqueta="(Estable)"
    if [ "$branch" == "401" ] || [ "$branch" == "405" ]; then
        etiqueta="(LTS / Estable)"
    fi
    
    alerta_seguridad=""
    if [ "$branch" == "401" ] || [ "$branch" == "402" ]; then
        alerta_seguridad=" ⚠️ [SIN SOPORTE DE SEGURIDAD]"
    fi
    
    php_req=""
    php_v=""
    if [ "$branch" == "401" ]; then
        php_req="PHP 8.1"
        php_v="8.1"
    elif [ "$branch" == "402" ] || [ "$branch" == "403" ]; then
        php_req="PHP 8.2"
        php_v="8.2"
    elif [ "$branch" == "404" ] || [ "$branch" == "405" ]; then
        php_req="PHP 8.3"
        php_v="8.3"
    else
        php_req="PHP 8.4"
        php_v="8.4"
    fi

    db_v="8.0"
    docroot="/var/www/html"
    if [ "$major" -ge 5 ]; then
        db_v="8.4"
        # La carpeta public se introdujo en Moodle 5.1
        if [ "$major" -gt 5 ] || [ "$minor" -ge 1 ]; then
            docroot="/var/www/html/public"
        fi
    fi

    nombres[$idx]="Moodle ${major}.${minor}.x $etiqueta - $php_req$alerta_seguridad"
    urls[$idx]="https://download.moodle.org/download.php/direct/stable${branch}/moodle-latest-${branch}.tgz"
    archivos[$idx]="moodle-latest-${branch}.tgz"
    php_versions[$idx]="$php_v"
    db_versions[$idx]="$db_v"
    docroot_versions[$idx]="$docroot"
    
    echo "$counter) ${nombres[$idx]}"
    
    idx=$((idx + 1))
    counter=$((counter + 1))
done

echo

# Ajustar counter ya que no sumamos la versión master
counter=$((counter - 1))

read -p "Ingresa tu opción (1-$counter): " opcion

# Validar entrada
if ! [[ "$opcion" =~ ^[0-9]+$ ]] || [ "$opcion" -lt 1 ] || [ "$opcion" -gt "$counter" ]; then
    echo "❌ Opción inválida. Por favor ejecuta el script nuevamente."
    exit 1
fi

opcion_idx=$((opcion - 1))
VERSION_SELECCIONADA="${nombres[$opcion_idx]}"
URL="${urls[$opcion_idx]}"
FILENAME="${archivos[$opcion_idx]}"
PHP_ELEGIDO="${php_versions[$opcion_idx]}"
DB_ELEGIDO="${db_versions[$opcion_idx]}"
DOCROOT_ELEGIDO="${docroot_versions[$opcion_idx]}"

echo "Has seleccionado: $VERSION_SELECCIONADA"
echo
echo "📥 Descargando..."

# Verificar si ya existe una instalación
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

# Descargar
if command -v curl &> /dev/null; then
    echo "📡 Usando curl..."
    curl -L "$URL" -o "$FILENAME"
elif command -v wget &> /dev/null; then
    echo "📡 Usando wget..."
    wget "$URL" -O "$FILENAME"
else
    echo "❌ No se encontró curl ni wget."
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "❌ Error al descargar Moodle. Verifica tu conexión a internet o la URL generada."
    exit 1
fi

echo "📦 Extrayendo Moodle..."
tar -xzf "$FILENAME"

if [ $? -ne 0 ]; then
    echo "❌ Error al extraer Moodle."
    exit 1
fi

echo "🧹 Limpiando archivos temporales..."
rm -f "$FILENAME"

echo "⚙️  Generando configuración .env para Docker..."
cat <<EOF > .env
PHP_VERSION=${PHP_ELEGIDO}
DB_VERSION=${DB_ELEGIDO}
DOCUMENT_ROOT=${DOCROOT_ELEGIDO}
EOF
echo "✅ Archivo .env creado correctamente con PHP ${PHP_ELEGIDO} y MySQL ${DB_ELEGIDO}."

echo
echo "✅ ¡Moodle descargado y extraído exitosamente!"
echo "📁 El código fuente está en la carpeta 'moodle/'"
