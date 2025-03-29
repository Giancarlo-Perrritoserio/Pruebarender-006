# Usamos PHP 8.2 con FPM
FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    nginx \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Verificar configuración de PHP (para depuración)
RUN php --ini

# Copiar archivos del proyecto
WORKDIR /var/www/html
COPY . .

# Instalar Composer y limpiar caché
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer clear-cache && composer install --no-dev --optimize-autoloader

# Crear archivo .env a partir de .env.example
RUN cp .env.example .env

# Permisos correctos para almacenamiento, cache y base de datos SQLite
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Generar clave de aplicación
RUN php artisan key:generate

# Migrar base de datos (Evita errores con PostgreSQL o SQLite)
RUN touch database/database.sqlite
RUN chmod -R 777 database/database.sqlite
RUN php artisan migrate --force

# Copiar configuración de Nginx
COPY default.conf /etc/nginx/sites-available/default

# Exponer el puerto HTTP 80
EXPOSE 80

# Comando para ejecutar Nginx y PHP-FPM
CMD service nginx start && php-fpm
