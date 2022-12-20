#!/etc/env bash

# Wait for database initialization
sleep 1
while ! mysqladmin ping -h db --silent; do
  echo "(Waiting for database)"
  sleep 1
done

if [ "${API_KEY}" != "<API key here>" ]; then
  echo "Installing WordPress Core"
  wp core install --path="/var/www/html" --url="http://localhost:8000" --title="WPLOCAL" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
else
  echo "Enter your API key in settings.env!"
fi
