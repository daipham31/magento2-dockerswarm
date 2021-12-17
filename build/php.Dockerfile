FROM php:7.4-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libsodium-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    git vim unzip cron nodejs npm \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN npm install -g n && n stable

RUN docker-php-ext-configure gd --with-jpeg \
    --with-freetype \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl

RUN docker-php-ext-install -j$(nproc) \
    opcache \
    bcmath \
    pdo_mysql \
    soap \
    xsl \
    zip \
    sockets \
    sodium

RUN pecl install -o xdebug-2.9.8

# Install Composer
RUN curl https://getcomposer.org/composer-2.phar -o composer \
    && mv composer /usr/local/bin/composer && chmod 750 /usr/local/bin/composer

CMD ["php-fpm"]