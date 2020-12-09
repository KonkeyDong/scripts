#!/bin/bash

echo "Running [download_docker.sh]..."

# Install Docker
curl -fsSL https://get.docker.com -o ~/get-docker.sh
sudo sh ~/get-docker.sh
sudo usermod -aG docker $(whoami)

echo "Checking if docker installed..."
sudo docker version
sudo docker run hello-world

# Install docker-compose
sudo pip3 install docker-compose

echo "Docker installation successful!"
echo "NOTE: log out / reboot your machine in order for the Docker group to take effect. Otherwise, you'll have to prepend [sudo] in front of all docker commands!

