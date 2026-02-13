# Guía de Instalación para macOS

Esta guía te ayudará a configurar el entorno de Savio Infra en tu Mac.

## Requisitos Previos

1.  **Docker Desktop para Mac**:
    - Descárgalo e instálalo desde [Docker Hub](https://docs.docker.com/desktop/install/mac-install/).
    - Asegúrate de elegir la versión correcta para tu chip:
        - **Apple Silicon** (M1, M2, M3, M4, M5 y sus variaciones): Descarga la versión para Apple Silicon.
        - **Intel**: Descarga la versión para Intel.
    - Abre Docker Desktop y asegúrate de que esté ejecutándose (verás el icono de la ballena en la barra de menú).

2.  **Terminal**:
    - Puedes usar la aplicación **Terminal** que viene instalada por defecto.
    - O cualquier otra terminal como iTerm2 o VS Code Terminal.

## Pasos de Instalación

1.  **Dar permisos de ejecución a los scripts**:
    Abre la terminal en la carpeta del proyecto y ejecuta:
    ```bash
    chmod +x *.sh
    ```

2.  **Ejecutar el script de configuración**:
    ```bash
    ./setup.sh
    ```
    O alternativamente:
    ```bash
    bash setup.sh
    ```

    Este script verificará que tengas Docker instalado y descargará Moodle automáticamente.

3.  **Levantar los servicios**:
    Si el script de configuración no lo hizo automáticamente, puedes ejecutar:
    ```bash
    docker compose up -d
    ```

4.  **Acceder a Moodle**:
    Abre tu navegador y ve a: [http://localhost](http://localhost)

## Solución de Problemas Comunes

### Error: "command not found: wget"
El script `bajar_moodle.sh` ha sido actualizado para usar `curl` si `wget` no está disponible, lo cual es común en macOS. Si aún tienes problemas, asegúrate de tener las herramientas de línea de comandos instaladas:
```bash
xcode-select --install
```

### Problemas con MySQL en Apple Silicon
Si el contenedor de la base de datos (`db`) se reinicia constantemente o falla con un error de arquitectura:
1.  Abre `docker-compose.yml`
2.  Busca la sección `db:`
3.  Agrega `platform: linux/x86_64` si la imagen nativa falla (aunque MySQL 8.0 generalmente soporta ARM64).
    ```yaml
    db:
      image: mysql:8.0
      platform: linux/x86_64
      ...
    ```
    *Nota: Esto hará que MySQL corra bajo emulación y puede ser lento.*
    Alternativamente, puedes cambiar la imagen a `mariadb:10.6` que tiene excelente soporte para ARM.

### Puertos Ocupados
Si recibes un error de que el puerto 80 o 3306 está en uso:
- **Puerto 80**: A veces macOS usa el puerto 80 para compartir archivos o servicios web locales. Puedes cambiar el puerto en `docker-compose.yml`:
  ```yaml
  ports:
    - "8080:80"
  ```
  Y luego acceder por `http://localhost:8080`.

- **Puerto 3306**: Si tienes instalada una base de datos MySQL localmente (con Homebrew o similar), deténla antes de iniciar Docker:
  ```bash
  brew services stop mysql
  ```
