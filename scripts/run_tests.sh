#!/etc/env ash

# Wait for database initialization
while ! mysqladmin ping -h db --silent; do
  echo "Waiting for database"
  sleep 1
done

cd /test_plugin
yes | bin/install-wp-tests.sh wordpress_test root wordpress db:3306 latest

composer run test
