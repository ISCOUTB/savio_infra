# Instrucciones especiales para Windows

## Configuración en Windows

### 1. Instalar Git Bash
1. Descarga Git desde: https://git-scm.com/download/win
2. Durante la instalación:
   - ✅ Selecciona "Git Bash Here" en el menú contextual
   - ✅ Usa Git desde la línea de comandos y también desde software de terceros
   - ✅ Usar OpenSSL library
   - ✅ Checkout Windows-style, commit Unix-style line endings

### 2. Instalar Docker Desktop
1. Descarga Docker Desktop desde: https://www.docker.com/products/docker-desktop
2. Instala y reinicia tu computadora
3. Asegúrate de que Docker Desktop esté ejecutándose (icono en la bandeja del sistema)

### 3. Usar Git Bash para todos los comandos
- **SIEMPRE** usa Git Bash para ejecutar los scripts
- **NUNCA** uses Command Prompt (cmd) o PowerShell
- Para abrir Git Bash:
  - Método 1: Click derecho en la carpeta del proyecto → "Git Bash Here"
  - Método 2: Busca "Git Bash" en el menú inicio

### 4. Verificar la instalación
Abre Git Bash y ejecuta:
```bash
docker --version
docker compose version
bash --version
```

### 5. Ejecutar el proyecto
```bash
# Navegar a la carpeta del proyecto
cd /ruta/a/savio_infra

# Ejecutar el script de configuración
bash setup.sh

# O ejecutar paso a paso:
bash bajar_moodle.sh
docker compose up
```

## Problemas comunes en Windows

### Error: "bash: command not found"
- **Solución:** Estás usando Command Prompt o PowerShell. Usa Git Bash.

### Error: "docker: command not found"
- **Solución:** Docker Desktop no está instalado o no está ejecutándose.

### Problemas con permisos de archivos
- En Windows con Git Bash, los problemas de permisos Unix son menos comunes.
- Si aparecen, generalmente se resuelven reiniciando Docker Desktop.

### Rutas con espacios
- Si tu carpeta tiene espacios en el nombre, usa comillas:
```bash
cd "/c/Users/Tu Nombre/Projects/savio_infra"
```
