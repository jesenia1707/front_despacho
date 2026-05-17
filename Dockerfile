FROM node:20-alpine AS build

WORKDIR /app

# Copiamos archivos de dependencias para aprovechar la caché de capas de Docker
COPY package*.json ./

# Instalamos dependencias limpias
RUN npm ci

# Copiamos todo el código del Front
COPY . .

# Compilamos con Vite (Vite genera por defecto la carpeta "dist")
RUN npm run build

# --- ETAPA 2: Servidor de Producción Seguro ---
FROM nginx:alpine

# Creamos el archivo de PID y cambiamos los permisos para el usuario no root (Exigencia de seguridad)
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /usr/share/nginx/html

USER nginx

# Copiamos los archivos estáticos generados por Vite en la etapa anterior
COPY --from=build /app/dist /usr/share/nginx/html

# Exponemos el puerto HTTP estándar
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]