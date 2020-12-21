#!/bin/bash

echo "Running [download_docker.sh]..."

# Docker
curl -fsSL https://get.docker.com -o ~/get-docker.sh
sudo sh ~/get-docker.sh
sudo usermod -aG docker $(whoami)

# Did we install correctly?
echo "Checking if Docker installed correctly..."
sudo docker version
echo
echo "If you saw a docker version number, it appears that Docker has installed correctly!"

# Docker-Compose
sudo pip3 install docker-compose

echo "Download and installation complete!"
echo "NOTE: you will have to log out / restart your machine in order for the recently added Docker group to take affect. Otherwise, you'll have to run the [sudo] command before every Docker command!"
echo "Once you have logged off / rebooted, try running: [docker run hello-world]"

