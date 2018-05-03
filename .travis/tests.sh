#!/bin/sh

set -o errexit

echo "Running Travis Tests"

# Fetching Env Vars
BUILD_CHECK_PHPCS=$(grep BUILD_CHECK_PHPCS .env | xargs)
BUILD_CHECK_PHPCS=${BUILD_CHECK_PHPCS#*=}

BUILD_CHECK_PHPUNIT=$(grep BUILD_CHECK_PHPUNIT .env | xargs)
BUILD_CHECK_PHPUNIT=${BUILD_CHECK_PHPUNIT#*=}

if [ $BUILD_CHECK_PHPCS == true ]; then
    echo "Running Code Sniffer for Code Quality"
    docker exec -it drupal vendor/bin/phpcbf --standard=Drupal -p ./web/themes/contrib ./web/modules/contrib
    docker exec -it drupal vendor/bin/phpcs --standard=Drupal -p ./web/themes/contrib ./web/modules/contrib
fi

if [ $BUILD_CHECK_PHPUNIT == true ]; then
    echo "Running phpunit tests"
    docker exec -it drupal vendor/bin/phpunit --testsuite=unit ./core
fi
