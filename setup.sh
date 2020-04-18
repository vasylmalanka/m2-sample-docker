#!/usr/bin/env bash
set -euo pipefail

cd $(dirname "$0")

docker-compose down -v

rm -rf www
mkdir www
sudo chmod g+s www
sudo chown $(id -u):33 www

docker-compose build --build-arg UID=$(id -u) php-fpm
docker-compose build redis
docker-compose up -d
docker exec -it m2-sample-php-fpm ../m2-install.sh

docker-compose down