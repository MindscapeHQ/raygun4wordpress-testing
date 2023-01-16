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
wp core install --path="/var/www/html" --url="http://localhost:8000" --title="wordpress" --admin_user=raygun --admin_password=raygunadmin --admin_email=test@raygun.com
cd /var/www/html
# Copy over testing plugins so they are visible to both containers
cp -rf /plugins/* wp-content/plugins

# Prepare:
# Activate plugins
wp plugin activate raygun4wordpress
wp plugin activate raygun-testing
# Admin login
curl --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt http://wordpress:80/wp-login.php
curl --silent --output /dev/null -L -b /tmp/cookie.txt -c /tmp/cookie.txt -d "log=raygun&pwd=raygunadmin&testcookie=1&rememberme=forever" http://wordpress:80/wp-login.php

# Raygun4WP settings:
rg4wp_status=1
rg4wp_usertracking=1
rg4wp_404s=1
rg4wp_js=1
rg4wp_pulse=1
rg4wp_ignoredomains="example.com"
rg4wp_tags="serverside"
rg4wp_js_tags="clientside"

##### Equality Assertion Function #####
# Params: Message, Value 1, Value 2
assert-equals() {
  E_PARAM_ERR=98
  E_ASSERT_FAILED=99
  if [ -z "${2}" ] || [ -z "${3}" ]; then
    return $E_PARAM_ERR
  fi
  if [ "${2}" != "${3}" ]; then
    echo "RAYGUN-TESTING: Assertion FAILED: \"${1}\""
	echo "${2} != ${3}"
    exit $E_ASSERT_FAILED
  else
    echo "RAYGUN-TESTING: Assertion passed: \"${1}\""
  fi
}

##### Serverside Test Runner #####
# Param: Function Name (String)
run-serverside-test() {
  if [ ! -z "${1}" ]; then
    curl --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt -d "test=${1}" http://wordpress:80/wp-admin/admin.php?page=test_page
  fi
}

run-serverside-tests() {
  run-serverside-test "test_error_handler_manually"
  run-serverside-test "test_uncaught_error"
  run-serverside-test "test_uncaught_exception"
  run-serverside-test "test_uncaught_errorexception"
}

########## External Tests ##########
test-settings() {
  echo "RAYGUN-TESTING: Applying settings"
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt http://wordpress:80/wp-admin/admin.php?page=rg4wp-settings)
  assert-equals "Raygun settings page loaded (1/2)" $response "200"
  # Unsuccessful curl attempt, might need _wpnonce...
  # curl -L -b /tmp/cookie.txt -c /tmp/cookie.txt -d "option_page=rg4wp&action=update&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings&rg4wp_apikey=${API_KEY}&rg4wp_ignoredomains=${rg4wp_ignoredomains}&rg4wp_usertracking=${rg4wp_usertracking}&rg4wp_status=${rg4wp_status}&rg4wp_js=${rg4wp_js}&rg4wp_404s=${rg4wp_404s}&rg4wp_tags=${rg4wp_tags}&rg4wp_js_tags=${rg4wp_js_tags}&rg4wp_pulse=${rg4wp_pulse}&action=update&page_options=rg4wp_status%2Crg4wp_apikey%2Crg4wp_tags%2Crg4wp_404s%2Crg4wp_js%2Crg4wp_usertracking%2Crg4wp_ignoredomains%2Crg4wp_pulse%2Crg4wp_js_tags&submitForm=Save+Changes" http://wordpress:80/wp-admin/options.php
  # Alternative:
  wp option update rg4wp_apikey $API_KEY
  wp option update rg4wp_tags $rg4wp_tags
  wp option update rg4wp_status $rg4wp_status
  wp option update rg4wp_usertracking $rg4wp_usertracking
  wp option update rg4wp_404s $rg4wp_404s
  wp option update rg4wp_js $rg4wp_js
  wp option update rg4wp_ignoredomains $rg4wp_ignoredomains
  wp option update rg4wp_pulse $rg4wp_pulse
  wp option update rg4wp_js_tags $rg4wp_js_tags
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null -G -b /tmp/cookie.txt -c /tmp/cookie.txt -d "settings-updated=true" http://wordpress:80/wp-admin/admin.php?page=rg4wp-settings)
  assert-equals "Raygun settings page loaded (2/2)" $response "200"
  
  echo "RAYGUN-TESTING: Verifying settings"
  assert-equals "rg4wp_apikey set" $(wp option get rg4wp_apikey) $API_KEY
  assert-equals "rg4wp_tags set" $(wp option get rg4wp_tags) $rg4wp_tags
  assert-equals "rg4wp_status set" $(wp option get rg4wp_status) $rg4wp_status
  assert-equals "rg4wp_usertracking set" $(wp option get rg4wp_usertracking) $rg4wp_usertracking
  assert-equals "rg4wp_404s set" $(wp option get rg4wp_404s) $rg4wp_404s
  assert-equals "rg4wp_js set" $(wp option get rg4wp_js) $rg4wp_js
  assert-equals "rg4wp_ignoredomains set" $(wp option get rg4wp_ignoredomains) $rg4wp_ignoredomains
  assert-equals "rg4wp_pulse set" $(wp option get rg4wp_pulse) $rg4wp_pulse
  assert-equals "rg4wp_js_tags set" $(wp option get rg4wp_js_tags) $rg4wp_js_tags
}

test-test-error() {
  echo "RAYGUN-TESTING: Sending test error"
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null -G -d "rg4wp_status=1&rg4wp_apikey=${API_KEY}&rg4wp_usertracking=${rg4wp_usertracking}&user=test%40raygun.com" http://wordpress:80/wp-content/plugins/raygun4wordpress/sendtesterror.php)
  assert-equals "Send test error page loaded" $response "200"
}

test-404() {
  echo "RAYGUN-TESTING: Testing 404"
  response=$(curl -X POST --write-out '%{http_code}' --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt http://wordpress:80/?page_id=404)
  assert-equals "page_id=404 not found" $response "404"
}

########## Run Tests ##########
test-settings
test-test-error
test-404

# Test serverside without async sending
run-serverside-tests

echo "RAYGUN-TESTING: Enabling async sending"
curl --silent --output /dev/null -b /tmp/cookie.txt -c /tmp/cookie.txt http://wordpress:80/wp-admin/admin.php?page=rg4wp-settings
wp option update rg4wp_async 1
curl --silent --output /dev/null -G -b /tmp/cookie.txt -c /tmp/cookie.txt -d "settings-updated=true" http://wordpress:80/wp-admin/admin.php?page=rg4wp-settings
assert-equals "rg4wp_async set" $(wp option get rg4wp_async) 1

# Test serverside again with async sending
run-serverside-tests

echo "******************************************************"
echo "Visit localhost:8000/wp-admin/admin.php?page=test_page"
echo "Username: \"raygun\" Password: \"raygunadmin\""
echo "******************************************************"
