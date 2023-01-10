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
  wp core install --path="/var/www/html" --url="http://wordpress:80" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
  cd /var/www/html
  # Copy over testing plugins so that they are visible to both containers
  cp -rf /plugins/* wp-content/plugins
  # Activate plugins
  wp plugin activate raygun4wordpress
  wp plugin activate raygun-testing
  # ---- Run Tests ----
  # curl -v -d "log=raygun&pwd=raygunadmin&rememberme=forever&wp-submit=Log+In" http://wordpress:80/wp-login.php
  # ---- End Tests ----
else
  echo "Enter your API key in settings.env!"
fi
