#!/etc/env bash

sleep 30 # Allow time for database setup
echo "prepare.sh running"
# Install WordPress if not already done so:
wp core install --path="/var/www/html" --url="http://localhost:8000" --title="LocalWordPress" --admin_user=raygun --admin_password=raygunadmin --admin_email=jared@raygun.com
# Scaffold the raygun-testing plugin if not already done so:
[ ! -d "/var/www/html/wp-content/plugins/raygun-testing" ] && mkdir -p /var/www/html/wp-content/plugins/raygun-testing && wp scaffold plugin raygun-testing
