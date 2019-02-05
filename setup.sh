#!/bin/bash

set -e

cd $(dirname "$0")

docker-compose down -v

rm -rf www
mkdir www
chmod 777 www

docker-compose build
docker-compose up -d
docker exec -it php-fpm ../m2-install.sh

docker-compose down

find www -type d -exec setfacl -d -m g::rwx {} \;
find www -type d -exec setfacl -d -m o::rwx {} \;