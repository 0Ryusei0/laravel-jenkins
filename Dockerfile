FROM php:8.2-fpm

# Install dependency sistem
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Install ekstensi PHP yang dibutuhkan Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy semua file Laravel ke container
COPY src/ /var/www

# Set permission (optional tapi direkomendasikan)
RUN chown -R www-data:www-data /var/www

# Expose port PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
