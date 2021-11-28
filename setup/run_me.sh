#!/bin/bash

# install useful programs
sudo apt install -y \
    neovim \
    ntfs-3g \
    curl \
    ranger \
    vlc \
    ruby \
    ruby-dev \
    build-essential \
    keepass2 \
    zsh \
    zlib1g-dev \
    liblzma-dev \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3 \
    python3-pip

# Note: to install ruby byebug and parallel-forkmanager,
#       you need to install ruby and ruby-dev!

# useful ruby gems. required for the parallel shred command
sudo gem install byebug parallel-forkmanager bundle ap crack nokogiri

# download youtube-dl alternative: yt-dlp (old youtube-dl is inactive now)
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

#Notes on parallel-forkmanager:
# https://www.rubydoc.info/gems/parallel-forkmanager/1.5.1/Parallel/ForkManager

source ${CONFIG} || source config.txt

function symbolic_link()
{
    local SOURCE=$1
    local DESTINATION=$2

    if [[ -d ${DESTINATION} ]]
    then
        rm ${DESTINATION}/*
        rm ${DESTINATION}/.* # hidden files (TODO: ignore . and .. dirs)
        rmdir ${DESTINATION}
    fi

    if [[ -e ${DESTINATION} ]]
    then
        rm ${DESTINATION}
    fi

    echo "Symbolic linking [${SOURCE}] to [${DESTINATION}] ..."
    ln -s ${SOURCE} ${DESTINATION}
}

# add symbol links
symbolic_link ${GIT_BASH_ALIASES} ${BASH_ALIASES}
symbolic_link ${GIT_BASH_RC} ${BASH_RC}

echo "Copying config directory ..."
mkdir -p ~/.config
cp -r ${GIT_CONFIG_DIR}/* ${CONFIG_DIR}

echo "run [download_vscode.sh] to download VS Code separately."
echo "run [download_joplin.sh] to download Joplin separately."
echo "run [download_docker.sh] to download Docker separately."

# add aliases
source ${BASH_RC}

