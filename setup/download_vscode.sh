#!/bin/bash

# download VS code: https://www.configserverfirewall.com/ubuntu-linux/install-visual-studio-code-ubuntu/
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update ; sudo apt install code

# download extensions
code --install-extension avli.clojure DavidAnson.vscode-markdownlint rebornix.ruby shd101wyy.markdown-preview-enhanced
