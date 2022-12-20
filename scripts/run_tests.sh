#!/etc/env bash

if [ "${API_KEY}" != "<API key here>" ]; then
  echo "Installing WordPress Core"
  wp core install --path="/var/www/html" --url="http://localhost:8000" --title="wplocal" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
else
  echo "Enter your API key in settings.env!"
fi
