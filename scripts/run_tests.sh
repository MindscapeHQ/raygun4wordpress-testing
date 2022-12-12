#!/etc/env bash

sleep 10 # allow time for database setup
echo "prepare.sh running"

cd /testing_plugin
yes | bin/install-wp-tests.sh wordpress_test root wordpress db:3306 latest
composer run test