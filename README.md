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

2. **Configura y descarga Moodle:**
   Ejecuta el script automático para configurar tu entorno y descargar Moodle:
   ```bash
   ./setup.sh
   ```
   (Alternativamente, puedes usar `./bajar_moodle.sh`)

   El script buscará dinámicamente las versiones estables más recientes de Moodle (desde la 4.1 LTS hasta 5.1+ o superiores) y te pedirá elegir cuál instalar. 
   
   **Automatización Docker:** El script generará un archivo `.env` configurando automáticamente la versión exacta de PHP (8.1 a 8.4) y de MySQL (8.0 o 8.4) requerida para la rama que hayas elegido. Todo quedará en su lugar incluyendo la extracción del código fuente en la carpeta `moodle/`.

3. **Levanta la infraestructura:**
   *(Si utilizaste `./setup.sh`, los contenedores se levantarán automáticamente).*
   Si necesitas levantarlos manualmente en el futuro, ejecuta:
   ```bash
   docker compose up -d --build
   ```
   Esto compilará el contenedor web inyectando las configuraciones de tu archivo `.env` e iniciará la base de datos.

4. **Accede a Moodle:**
   Abre tu navegador y visita:
   [http://localhost](http://localhost)

5. **Desarrolla plugins o temas:**
   - El código fuente de Moodle está en la carpeta `moodle/`.
   - Puedes crear carpetas para plugins en `moodle/local/` o temas en `moodle/theme/`.
   - Los cambios se reflejan automáticamente en el contenedor web.

## Credenciales por defecto
- **Base de datos:**
  - Host: `db` (dentro de Docker)
  - Nombre DB: `alpydb`
  - Usuario: `alpyuser`
  - Contraseña: `alpypass`
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

- Si necesitas reiniciar los servicios o aplicar cambios profundos (ej. instalaste una nueva versión):
  ```bash
  docker compose down
  docker compose up -d --build
  ```
- Para instalar nuevas dependencias en PHP, edita el `Dockerfile` y reconstruye el contenedor web:
  ```bash
  docker compose build web
  docker compose up -d
  ```

## Recursos útiles
- [Documentación oficial de Moodle](https://moodledev.io/)
- [Guía de desarrollo de plugins](https://moodledev.io/docs/plugins)
- [Instrucciones específicas para Windows](WINDOWS.md) 📋
- [Instrucciones específicas para macOS](MACOS.md) 🍎

---

¿Dudas o problemas? Contacta a tu profesor o revisa la sección de troubleshooting.
