#!/bin/bash

sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 97203C7B3ADCA79D # add missing GPK public key
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add –
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt update
sudo apt install plexmediaserver

echo "INSTALLATION COMPLETE! START PLEX WITH THE FOLLOWING COMMAND: "
echo "sudo systemctl start plexmediaserver"
echo
echo "CHECK PLEX RUNNING STATUS WITH: "
echo "sudo systemctl status plexmediaserver"
echo
echo "FOLLOW SETTING UP WEB INTERFACE HERE: "
echo "https://hostadvice.com/how-to/how-to-install-plex-media-server-on-ubuntu-20-04/"
echo
echo "--- SETTING PERMISSIONS ---"
echo "Remember to run 'chmod 755 -R .' from whatever directory will contain all of your media."
echo "You might need to run 'chmod 755 -R' for the mounted directory as well." 
