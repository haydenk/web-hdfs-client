FROM php:latest

RUN useradd -m -p hdfs -s /bin/bash hdfs \
    && apt-get update && apt-get install -y zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER hdfs
WORKDIR "/home/hdfs/web-hdfs-client"
