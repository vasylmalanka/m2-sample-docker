Docker configuration for Magento 2 Open Source with Sample Data running on PHP-FPM 7.3, MySQL 5.7, Elasticsearch 7, Nginx, Composer.

### Prerequisites

Install Docker CE and Docker Compose.

### Installing

Steps to install Magento 2 with sample data:

1. Copy *.env.sample* into *.env*: `cp .env.sample .env` .
2. Edit *.env* with setting of public and private keys from your account on Magento Marketplace.
3. Run `./setup.sh`
4. Add a line to your hosts file `127.0.0.1 m2-sample.loc`
5. Run `docker-compose up`.
6. Open `m2-sample.loc` in browser and have fun ;)

### Debugging

1. Stop containers `docker-compose down`.
2. Write your current IP address into `XDEBUG_REMOTE_HOST` variable in `docker-compose.yml`.
3. Set `XDEBUG_ENABLE` to `"true"` in `docker-compose.yml`.
4. In PhpStorm go to File -> Settings... -> Languages & Frameworks -> PHP -> Servers.
5. Set `Host`:`m2-sample.loc` and some unique `Title`.
6. Check `use path mappings` and add `/var/www/html/m2` opposite to `www` directory.
7. In `docker-compose.yml` set `PHP_IDE_CONFIG: "serverName=<Title>"` (`Title` from step 5).
8. Re-build containers `docker-compose build --build-arg UID=$(id -u) fpm`.
9. Run containers with new configuration `docker-compose up`.
10. Enable `Start Listening for PHP Debug Connections`.

### To do
1. Make host configurable.
2. Update README.md:
  - on which platform tested
  - move integration test configuration to override.yml
  - local composer cache usage
  - rework file permissions

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
