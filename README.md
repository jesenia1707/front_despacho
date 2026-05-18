# Innovatech Chile - Módulo de Despachos (Frontend)

Este repositorio contiene la interfaz de usuario (UI) para el sistema de Despachos de Innovatech Chile, construida utilizando React y Vite.

## Requerimientos e Infraestructura
- **Framework/Librería:** React (Vite)
- **Entorno de Compilación:** Node 20 (Alpine)
- **Servidor de Producción:** Nginx (Alpine)
- **Puerto expuesto:** 80

## Contenedorización y Buenas Prácticas (DevOps) - IE1
El proyecto implementa un `Dockerfile` optimizado utilizando **Multi-stage build**:
1. **Etapa de Compilación (Build):** Se utiliza una imagen ligera de Node para instalar las dependencias y generar los archivos estáticos de producción (`dist`), eliminando posteriormente la caché para optimizar el almacenamiento.
2. **Etapa de Producción:** Se transfieren únicamente los archivos compilados a una imagen limpia de Nginx Alpine, minimizando drásticamente el tamaño final de la imagen.

*Seguridad:* Siguiendo el principio de mínimo privilegio, el servidor Nginx está configurado para ejecutarse bajo un usuario **No-Root** (`nginx`), evitando riesgos de ejecución con privilegios de administrador dentro de AWS EC2.

## Configuración de Orquestación (Docker Compose) - IE2
El archivo `docker-compose.yml` permite levantar el contenedor de manera aislada o conjunta enlazando el puerto local con el puerto estándar HTTP (`80:80`), asegurando que la aplicación sea accesible públicamente en la web mediante la IP de la instancia.

## Automatización CI/CD - IE4
Este repositorio cuenta con un pipeline automatizado en **GitHub Actions** (`deploy.yml`). Al realizar un `git push` en la rama `deploy`, el workflow se dispara automáticamente para:
1. Construir la imagen Docker de manera automatizada.
2. Publicarla en el registro de contenedores (Docker Hub).
3. Conectarse vía SSH a la instancia EC2 de AWS para descargar la nueva imagen y reiniciar el servicio sin fricción.

---

## Despliegue Local
Para levantar el contenedor del Frontend de forma local con Docker, ejecute en su terminal:
```bash
docker-compose up --build -d