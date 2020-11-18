#!/usr/bin/env bash
set -euo pipefail

cd $(dirname "$0")

set -o allexport
source .env
set +o allexport

cd m2
composer global config http-basic.repo.magento.com "$PUBLICKEY" "$PRIVATEKEY"
echo "Y" | composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition magento
cd ../
cp -R m2/magento/* m2/
rm -r m2/magento
cd m2

bin/magento setup:install --backend-frontname="admin" --db-host="$MYSQL_DBHOST" --db-name="$MYSQL_DATABASE" \
    --db-password="$MYSQL_ROOT_PASSWORD" --db-user="root" --use-rewrites="1" --admin-user="$MAGENTO_ADMIN_USERNAME" \
    --admin-password="$MAGENTO_ADMIN_PASSWORD" --base-url="http://m2-sample.loc" --admin-email="admin@example.com" \
    --admin-firstname="Admin" --admin-lastname="Admin" --magento-init-params="MAGE_MODE=developer" \
    --elasticsearch-host=elasticsearch

bin/magento deploy:mode:set developer

if [ "$DEPLOY_SAMPLE_DATA" = "true" ]; then
    cat << EOF | tee var/composer_home/auth.json
    {
        "http-basic": {
            "repo.magento.com": {
                "username": "$PUBLICKEY",
                "password": "$PRIVATEKEY"
            }
        }
    }
EOF
    bin/magento sampledata:deploy
fi

bin/magento setup:upgrade

bin/magento indexer:reindex

echo "Y" | bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=m2-sample-redis --cache-backend-redis-db=0
echo "Y" | bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=m2-sample-redis --page-cache-redis-db=1
echo "Y" | bin/magento setup:config:set --session-save=redis --session-save-redis-host=m2-sample-redis --session-save-redis-db=2 --session-save-redis-log-level=3

bin/magento config:set dev/css/merge_css_files 1
bin/magento config:set dev/css/minify_files 1
bin/magento config:set dev/js/merge_files 1
bin/magento config:set dev/js/minify_files 1

bin/magento module:disable Magento_TwoFactorAuth
bin/magento cache:flush
