# Usa la imagen oficial de PHP con FPM
FROM php:8.2-fpm

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia los archivos del proyecto
COPY . .

# Instala dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Permisos para almacenamiento y cache
RUN chmod -R 777 storage bootstrap/cache

# Expone el puerto 9000 para FPM
EXPOSE 9000

# Comando de inicio
CMD ["php-fpm"]
