FROM php:7.3-fpm

# Install packages reqiuired for installation of PHP libraries
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        curl \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        procps \
        unzip \
        libzip-dev \
# Install MySQL client for integration tests
        default-mysql-client \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
# Install and configure PHP libraries required for Magento 2
    && docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mysqli pdo_mysql soap zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install exif \
    && docker-php-ext-install xsl \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/*

# Install Xdebug
RUN yes | pecl install xdebug

# Adjust PHP parameters
COPY php.ini /usr/local/etc/php/conf.d/additional.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN chmod 777 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
RUN chmod 644 /usr/local/etc/php-fpm.d/www.conf

COPY docker-php-entrypoint /usr/local/bin/

ARG UID
RUN useradd -m -g www-data -G sudo,root,www-data -u $UID web

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chown web:www-data /usr/local/bin/composer

COPY ./m2-install.sh /var/www/html/
RUN chown web:www-data /var/www/html/m2-install.sh

WORKDIR /var/www/html/m2

USER web
