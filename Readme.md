Docker configuration for Magento 2 Open Source with Sample Data running on PHP-FPM 7.2, MySQL 5.7, Nginx, Composer.

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
