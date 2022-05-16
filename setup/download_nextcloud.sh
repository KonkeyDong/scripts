#!/bin/bash

echo "See walkthrough here: https://pimylifeup.com/raspberry-pi-nextcloud-server/"

echo "Installing Apache2..."
sudo apt install apache2

echo "Installing PHP..."
sudo apt install php8.0 php8.0-gd php8.0-sqlite3 php8.0-curl php8.0-zip php8.0-xml php8.0-mbstring php8.0-mysql php8.0-bz2 php8.0-intl php-smbclient php8.0-imap php8.0-gmp libapache2-mod-php8.0

echo "Restarting Apache..."
sudo service apache2 restart

# Add MySql stuff here...

echo "Downloading Nextcloud...."
mkdir -p /var/www/
cd /var/www
sudo wget https://download.nextcloud.com/server/releases/latest.tar.bz2
sudo tar -xvf latest.tar.bz2
sudo mkdir -p /var/www/nextcloud/data
sudo chown -R www-data:www-data /var/www/nextcloud/
sudo chmod 750 /var/www/nextcloud/data

echo "Not completed. Please follow from 'Configuring Apache for Nextcloud' at https://pimylifeup.com/raspberry-pi-nextcloud-server/"
echo "ABORTING...."

