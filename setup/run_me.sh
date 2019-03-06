#!/bin/bash

# install useful programs
sudo apt install neovim ntfs-3g youtube-dl curl ranger vlc ruby ruby-dev -y

# useful ruby gems. required for the parallel shred command
sudo gem install byebug parallel-forkmanager

Notes on parallel-forkmanager:
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

# add aliases
source ${BASH_RC}
