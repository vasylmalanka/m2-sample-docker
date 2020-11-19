#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

docker-compose down -v

rm -rf www
mkdir www
sudo chmod g+s www
sudo chown "$(id -u)":33 www

docker-compose build --build-arg UID="$(id -u)" fpm
docker-compose up -d
docker-compose exec fpm ../m2-install.sh

docker-compose up -d nginx
