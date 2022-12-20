#!/etc/env ash

cd /repository
echo "Removing API key from settings.env"
sed -i "/^API_KEY=/s/=.*/=<API key here>/" settings.env
