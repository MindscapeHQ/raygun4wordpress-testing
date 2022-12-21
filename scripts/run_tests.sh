#!/etc/env bash

if [ "${API_KEY}" != "<API key here>" ]; then
  echo "Installing WordPress Core"
  wp core install --path="/var/www/html" --url="http://wordpress:80" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
else
  echo "Enter your API key in settings.env!"
fi
