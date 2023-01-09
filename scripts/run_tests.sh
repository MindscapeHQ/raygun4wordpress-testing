#!/etc/env bash

# wordpress container health check values:
interval=1 # Seconds
retries=20
timeout=5 # Seconds

# Wait for the wordpress server:
connected=0
for i in $(seq $retries); do
  sleep $interval
  curl -m $timeout -s --fail wordpress:80
  [ $? -eq 0 ] && connected=1 && break
done
[ $connected -eq 0 ] && echo "Could not connect to wordpress!" && exit 1

if [ "${API_KEY}" != "<API key here>" ]; then
  echo "Installing WordPress Core"
  # change to wordpress:80
  wp core install --path="/var/www/html" --url="http://localhost:8000" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
  curl -v -d "log=raygun&pwd=raygunadmin&rememberme=forever&wp-submit=Log+In" http://wordpress:80/wp-login.php
  curl -v -d "action=activate&plugin=raygun4wordpress%2Fraygun4wp.php&plugin_status=all" http://wordpress:80/wp-admin/plugins.php
  curl -v -d "activate=true&plugin_status=all" http://wordpress:80/wp-admin/plugins.php
else
  echo "Enter your API key in settings.env!"
fi
