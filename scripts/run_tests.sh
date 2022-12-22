#!/etc/env bash

# wordpress container health check values:
interval=1 # Seconds
retries=20
timeout=5 # Seconds

# Wait for the wordpress server:
sleep 2 # Give initial setup time
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
else
  echo "Enter your API key in settings.env!"
fi
