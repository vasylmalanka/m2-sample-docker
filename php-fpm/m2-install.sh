#!/bin/bash
set -e

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
    --admin-firstname="Admin" --admin-lastname="Admin" --magento-init-params="MAGE_MODE=developer"
bin/magento deploy:mode:set developer
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
bin/magento setup:upgrade
bin/magento indexer:reindex
bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
head -n -2 app/etc/env.php > app/etc/env.php.tmp
mv app/etc/env.php.tmp app/etc/env.php
sed -i 's/session/session_old/g' app/etc/env.php
cat << EOF | tee -a app/etc/env.php
    ],
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => 'redis',
            'port' => '6379',
            'password' => '',
            'timeout' => '2.5',
            'persistent_identifier' => '',
            'database' => '2',
            'compression_threshold' => '2048',
            'compression_library' => 'gzip',
            'log_level' => '3',
            'max_concurrency' => '6',
            'break_after_frontend' => '5',
            'break_after_adminhtml' => '30',
            'first_lifetime' => '600',
            'bot_first_lifetime' => '60',
            'bot_lifetime' => '7200',
            'disable_locking' => '0',
            'min_lifetime' => '60',
            'max_lifetime' => '2592000',
        ],
    ],
];
EOF
bin/magento app:config:import

bin/magento config:set dev/css/merge_css_files 1
bin/magento config:set dev/css/minify_files
bin/magento config:set dev/js/merge_files 1
bin/magento config:set dev/js/minify_files 1
bin/magento config:set catalog/frontend/flat_catalog_category 1
bin/magento config:set catalog/frontend/flat_catalog_product 1

bin/magento cache:flush

rm -rf var/cache var/composer_home var/generation var/page_cache var/view_preprocessed pub/static
bin/magento setup:static-content:deploy -f
