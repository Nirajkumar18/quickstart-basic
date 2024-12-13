# Use the official PHP image with FPM
FROM php:7.4-fpm

# Install system dependencies and required PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy application files to container
COPY . /app

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /app \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Configure Composer to allow necessary plugins
RUN composer config --no-plugins allow-plugins.kylekatarnls/update-helper true

# Install PHP dependencies without running scripts
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Expose port 8000
EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

