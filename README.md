# Savio Infra: Infraestructura replicable para desarrollo de Moodle

Este proyecto permite a estudiantes levantar una instancia local de Moodle para desarrollar plugins, temas y realizar pruebas en sus equipos usando Docker.

## Requisitos previos
- Docker y Docker Compose instalados en tu equipo.
- Git (opcional, para clonar el repositorio).
- **Terminal compatible con bash:**
  - **Linux/macOS:** Terminal nativo (bash disponible por defecto)
  - **Windows:** Git Bash (se instala con Git) o WSL (Windows Subsystem for Linux)

## Pasos de instalación y uso

### Importante: Uso de terminal
- **Linux/macOS:** Abre tu terminal nativo (Revisa [instrucciones específicas para Mac](MACOS.md))
- **Windows:** Abre Git Bash (NO uses Command Prompt o PowerShell)

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/ISCOUTB/savio_infra.git
   cd savio_infra
   ```

2. **Descarga Moodle:**
   Ejecuta el script para descargar la versión de Moodle que prefieras:
   ```bash
   bash bajar_moodle.sh
   ```
   El script te permitirá elegir entre:
   - Moodle 4.1.13 (LTS - Soporte a largo plazo)
   - Moodle 4.5.2 (Versión estable)
   - Moodle 5.0+ (Última versión disponible)
   
   Esto creará la carpeta `moodle/` con el código fuente.

3. **Levanta la infraestructura:**
   ```bash
   docker compose up
   ```
   Esto iniciará los servicios de base de datos y servidor web.

4. **Accede a Moodle:**
   Abre tu navegador y visita:
   [http://localhost](http://localhost)

5. **Desarrolla plugins o temas:**
   - El código fuente de Moodle está en la carpeta `moodle/`.
   - Puedes crear carpetas para plugins en `moodle/local/` o temas en `moodle/theme/`.
   - Los cambios se reflejan automáticamente en el contenedor web.

## Credenciales por defecto
- **Base de datos:**
  - Usuario: `alpyuser`
  - Contraseña: `alpypass`
  - Base de datos: `alpydb`
  - Host: `db` (dentro de Docker)
- **Root MySQL:**
  - Usuario: `root`
  - Contraseña: `alpyroot`

## Troubleshooting

### Problemas con terminal en Windows
- **Error: "bash: command not found"**
  - Asegúrate de usar Git Bash, no Command Prompt o PowerShell
  - Descarga Git desde: https://git-scm.com/download/win
  - Durante la instalación, selecciona "Git Bash Here" en el menú contextual

### Problemas generales
- Si tienes problemas con permisos en las carpetas, ejecuta:
  ```bash
  sudo chown -R $USER:$USER moodle moodledata
  ```
  **Nota:** En Windows con Git Bash, este comando puede no ser necesario.

- Si necesitas reiniciar los servicios:
  ```bash
  docker compose down
  docker compose up
  ```
- Para instalar nuevas dependencias PHP, edita el `Dockerfile` y reconstruye el contenedor web:
  ```bash
  docker compose build web
  docker compose up
  ```

## Recursos útiles
- [Documentación oficial de Moodle](https://moodledev.io/)
- [Guía de desarrollo de plugins](https://moodledev.io/docs/plugins)
- [Instrucciones específicas para Windows](WINDOWS.md) 📋
- [Instrucciones específicas para macOS](MACOS.md) 🍎

---

¿Dudas o problemas? Contacta a tu profesor o revisa la sección de troubleshooting.
