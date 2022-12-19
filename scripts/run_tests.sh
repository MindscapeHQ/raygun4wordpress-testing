#!/etc/env ash

# Wait for database initialization
sleep 1
while ! mysqladmin ping -h db --silent; do
  echo "(Waiting for database)"
  sleep 1
done

cd /test_plugin
if [ -f raygun4wp.php ]; then
  if [ "${API_KEY}" != "<API key here>" ]; then
    # If a specific version of WordPress needs to be tested, change it here \/
    yes | bin/install-wp-tests.sh wordpress_test root wordpress db:3306 latest
    composer run test
  else
    echo "Enter your API key in settings.env!"
  fi
else
  echo "raygun4wp missing: did you run \"docker compose --profile update up\"?"
fi
