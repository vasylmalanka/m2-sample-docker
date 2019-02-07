#!/bin/bash

set -e

cd $(dirname "$0")

docker-compose down -v

rm -rf www
mkdir www
chmod g+s www
chown $(id -u):33 www

docker-compose build --build-arg UID=$(id -u) php-fpm
docker-compose build redis
docker-compose up -d
docker exec -it php-fpm ../m2-install.sh

docker-compose down