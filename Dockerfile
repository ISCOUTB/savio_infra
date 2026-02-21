# Usar la imagen oficial de PHP con Apache como base
ARG PHP_VERSION=8.1
FROM php:${PHP_VERSION}-apache

# Actualizar el gestor de paquetes e instalar las dependencias necesarias para la extensión zip
RUN apt-get update && apt-get install -y \
    libzip-dev libpng-dev libicu-dev \
    && docker-php-ext-install zip mysqli gd intl\
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Custom configs for php
COPY custom.ini /usr/local/etc/php/conf.d/

# Configurar Apache para usar un DocumentRoot dinámico (por defecto /var/www/html)
# Esto es esencial para Moodle 5.0+ que requiere que la carpeta /public sea el DocumentRoot
ARG DOCUMENT_ROOT=/var/www/html
ENV DOCUMENT_ROOT=${DOCUMENT_ROOT}
RUN sed -ri -e 's!/var/www/html!${DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${DOCUMENT_ROOT}/!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Exponer el puerto 80
EXPOSE 80

# Comando por defecto para iniciar Apache en primer plano
CMD ["apache2-foreground"]
