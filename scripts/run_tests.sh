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

# Check API key input:
if [ "${API_KEY}" = "<API key here>" ]; then
  echo "Enter your API key in settings.env!"
  exit 1
fi

echo "Installing WordPress Core"
wp core install --path="/var/www/html" --url="http://wordpress:80" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
cd /var/www/html
# Copy over testing plugins so they are visible to both containers
cp -rf /plugins/* wp-content/plugins

# Prepare:
# Activate plugins
wp plugin activate raygun4wordpress
wp plugin activate raygun-testing
# Admin login
curl --write-out '%{http_code}' --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt http://wordpress:80/wp-login.php
curl --write-out '%{http_code}' --silent --output /dev/null -L -b /tmp/cookie.txt -c /tmp/cookie.txt -d "log=raygun&pwd=raygunadmin&testcookie=1&rememberme=forever" http://wordpress:80/wp-login.php

# Raygun4WP settings
rg4wp_tags=
rg4wp_status=0
rg4wp_usertracking=0
rg4wp_404s=1
rg4wp_js=1
rg4wp_ignoredomains=
rg4wp_pulse=
rg4wp_js_tags=
rg4wp_async=0

# wpnonce Generator
generate_wpnonce() {
  wpnonce=$(wp eval 'echo wp_create_nonce();')
}

##### Assertion Function #####
# params: Message, Value 1, Value 2
assert_equals() {
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99
  if [ -z "${2}" ] || [ -z "${3}" ]; then
    return $E_PARAM_ERR
  fi
  if [ ! $2 -eq $3 ]; then
    echo "RAYGUN-TESTING: Assertion FAILED: \"${1}\""
    exit $E_ASSERT_FAILED
  else
    echo "RAYGUN-TESTING: Assertion passed: \"${1}\""
  fi
}

########## Run Tests ##########
echo "RAYGUN-TESTING: Testing settings page and applying settings"
# TODO: find the actual raygun settings page to post to
curl -G -b /tmp/cookie.txt -c /tmp/cookie.txt -d "option_page=rg4wp&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings" http://wordpress:80/wp-admin/options.php
#curl -L -b /tmp/cookie.txt -c /tmp/cookie.txt -d "option_page=rg4wp&action=update&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings&rg4wp_apikey=${API_KEY}&rg4wp_ignoredomains=${rg4wp_ignoredomains}&rg4wp_usertracking=${rg4wp_usertracking}&rg4wp_status=${rg4wp_status}&rg4wp_js=${rg4wp_js}&rg4wp_404s=${rg4wp_404s}&rg4wp_tags=${rg4wp_tags}&rg4wp_js_tags=${rg4wp_js_tags}&rg4wp_pulse=${rg4wp_pulse}&action=update&page_options=rg4wp_status%2Crg4wp_apikey%2Crg4wp_tags%2Crg4wp_404s%2Crg4wp_js%2Crg4wp_usertracking%2Crg4wp_ignoredomains%2Crg4wp_pulse%2Crg4wp_js_tags&submitForm=Save+Changes" http://wordpress:80/wp-admin/options.php
#curl -G -b /tmp/cookie.txt -c /tmp/cookie.txt -d "page=rg4wp-settings&settings-updated=true" http://wordpress:80/wp-admin/admin.php

#curl -s -G -d "rg4wp_status=1&rg4wp_apikey=${API_KEY}&rg4wp_usertracking=&user=test%40raygun.com" http://wordpress:80/wp-content/plugins/raygun4wordpress/sendtesterror.php

#assert_equals "rg4wp_apikey set" $rg4wp_apikey $(wp option get 'rg4wp_apikey')
