# Use php and apache image
FROM php:7.4-apache


# Setting working directory to /var/www/html
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    curl

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY . /var/www/html/

# Install dependencies using Composer
RUN composer install --no-plugins --no-scripts --no-autoloader


# Expose port 80 
EXPOSE 80

# Start PHP-apache
CMD ["apache2-foreground"]
