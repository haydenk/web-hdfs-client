FROM php:latest

RUN useradd -m -p hdfs -s /bin/bash hdfs \
    && apt-get update && apt-get install -y zip libicu-dev libmcrypt-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring exif zip opcache pcntl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && pecl install apcu && docker-php-ext-enable apcu \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && { \
        echo 'xdebug.default_enable=1'; \
        echo 'xdebug.remote_enable=1'; \
        echo 'xdebug.remote_handler=dbgp'; \
        echo 'xdebug.remote_autostart=0'; \
        echo 'xdebug.remote_connect_back=1'; \
        echo 'xdebug.remote_port=9000'; \
        echo "xdebug.remote_host=127.0.0.1"; \
        echo 'xdebug.profiler_enable=0'; \
        echo 'xdebug.profiler_enable_trigger=1'; \
        echo 'xdebug.profiler_output_dir="/tmp"'; \
        echo 'xdebug.max_nesting_level=1200'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER hdfs
WORKDIR "/home/hdfs/web-hdfs-client"
