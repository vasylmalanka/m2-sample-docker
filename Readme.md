Docker configuration for Magento 2 Open Source with Sample Data running on PHP-FPM 7.3, MySQL 5.7, Elasticsearch 7, Nginx, Composer.

### Prerequisites

Install Docker CE and Docker Compose.

### Installing

Steps to install Magento 2 with sample data:

1. Copy *.env.sample* into *.env*: `cp .env.sample .env` .
2. Edit *.env* with setting of public and private keys from your account on Magento Marketplace.
3. Run `./setup.sh`
4. Add a line to your hosts file `127.0.0.1 <your.host>`
5. Open `<your.host>` in browser and have fun ;)

### Debugging

1. Stop FPM container `docker-compose stop fpm`.
2. Write your current IP address into `XDEBUG_REMOTE_HOST` variable in `docker-compose.yml`.
3. Set `XDEBUG_ENABLE` to `"true"` in `docker-compose.yml`.
4. In PhpStorm go to File -> Settings... -> Languages & Frameworks -> PHP -> Servers.
5. Set `Host`:`<your.host>` and some unique `Title`.
6. Check `use path mappings` and add `/var/www/html/m2` opposite to `www` directory.
7. In `docker-compose.yml` set `PHP_IDE_CONFIG: "serverName=<Title>"` (`Title` from step 5).
8. Re-build FPM container `docker-compose build --build-arg UID=$(id -u) fpm`.
9. Run FPM container with new configuration `docker-compose up --force-recreate fpm`.
10. Enable `Start Listening for PHP Debug Connections`.

### To do
1. Make host configurable (https://stackoverflow.com/questions/56649582/substitute-environment-variables-in-nginx-config-from-docker-compose/62844707#62844707)
2. Change links -> depends_on[]
3. Update README.md:
  - how to use Composer cache
  - on which platform tested
4. move integration test configuration to override.yml
5. Build PHP image and push it to Docker hub
6. rework file permissions

## Built With

* [Docker Community Edition](https://docs.docker.com/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Bash](https://www.gnu.org/software/bash/)

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/vasylmalanka/m2-sample-docker/tags). 

## Authors

* **Vasyl Malanka** - [https://github.com/vasylmalanka](https://github.com/vasylmalanka)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/nishanths/license/blob/master/LICENSE) file for details.
