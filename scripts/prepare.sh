#!/etc/env bash

sleep 10 # allow time for database setup
echo "prepare.sh running"
if [ ! -d "/var/www/html/wp-content/plugins/raygun-testing" ]
then
  echo "prepare.sh: performing first time setup procedure"
  # install WordPress core if not already done so
  wp core install --path="/var/www/html" --url="http://localhost:8000" --title="LocalWordPress" --admin_user=raygun --admin_password=raygunadmin --admin_email=jared@raygun.com
  # scaffold the raygun-testing plugin if not already done so
  mkdir -p /var/www/html/wp-content/plugins/raygun-testing
  wp scaffold plugin raygun-testing
fi

cd /var/www/html/wp-content/plugins/raygun-testing
yes | bin/install-wp-tests.sh wordpress_test root wordpress db:3306 latest
composer run test