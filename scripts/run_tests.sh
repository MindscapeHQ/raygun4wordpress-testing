#!/etc/env ash

# Wait for database initialization
sleep 1
while ! mysqladmin ping -h db --silent; do
  echo "Waiting for database"
  sleep 1
done

cd /test_plugin
if [ -f raygun4wp.php ]; then
  yes | bin/install-wp-tests.sh wordpress_test root wordpress db:3306 latest
  composer run test
else
  echo "raygun4wp missing: did you run \"docker compose --profile update up\"?"
fi
