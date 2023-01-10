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
  wp core install --path="/var/www/html" --url="http://localhost:8000" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
  cd /var/www/html
  # Copy over testing plugins so that they are visible to both containers
  cp -rf /plugins/* wp-content/plugins
  # Activate plugins
  wp plugin activate raygun4wordpress
  wp plugin activate raygun-testing
  # Admin login
  curl -d "log=raygun&pwd=raygunadmin&rememberme=forever&wp-submit=Log+In" http://wordpress:80/wp-login.php
  # Generate wpnonce
  wpnonce=$(wp eval 'echo wp_create_nonce();')
  
  # ---- Run Tests ----
  # Apply settings (tests settings page) NOTE: not working yet, backup option is to use wp option update
  curl -v -d "option_page=rg4wp&action=update&_wpnonce=${wpnonce}&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings&rg4wp_apikey=${API_KEY}&rg4wp_ignoredomains=&rg4wp_usertracking=1&rg4wp_status=1&rg4wp_js=1&rg4wp_404s=1&rg4wp_tags=&rg4wp_js_tags=&rg4wp_pulse=1&action=update&page_options=rg4wp_status%2Crg4wp_apikey%2Crg4wp_tags%2Crg4wp_404s%2Crg4wp_js%2Crg4wp_usertracking%2Crg4wp_ignoredomains%2Crg4wp_pulse%2Crg4wp_js_tags&submitForm=Save+Changes" -H "Content-Type: application/x-www-form-urlencoded" http://wordpress:80/wp-admin/options.php
  
  # ---- End Tests ----
else
  echo "Enter your API key in settings.env!"
fi
