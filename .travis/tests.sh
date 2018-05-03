

set -o errexit

echo "Running Travis Tests"

# Fetching Env Vars
BUILD_CHECK_PHPCS=$(grep BUILD_CHECK_PHPCS .env | xargs)
BUILD_CHECK_PHPCS=${BUILD_CHECK_PHPCS#*=}

BUILD_CHECK_PHPUNIT=$(grep BUILD_CHECK_PHPUNIT .env | xargs)
BUILD_CHECK_PHPUNIT=${BUILD_CHECK_PHPUNIT#*=}

if [ $BUILD_CHECK_PHPUNIT == true ]; then
    cat .env
fi