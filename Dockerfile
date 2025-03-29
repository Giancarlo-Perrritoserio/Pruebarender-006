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
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Verificar configuración de PHP (para depuración)
RUN php --ini

# Copiar archivos del proyecto
WORKDIR /var/www/html
COPY . .

# Instalar Composer y limpiar caché
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Limpiar caché de Composer y ejecutar instalación
RUN composer clear-cache && composer install --no-dev --optimize-autoloader

# Permisos correctos para almacenamiento y cache de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto
EXPOSE 8000

# Comando por defecto para ejecutar PHP-FPM
CMD ["php-fpm"]
