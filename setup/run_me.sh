#!/bin/bash

# install useful programs
sudo apt install neovim ntfs-3g youtube-dl curl ranger vlc -y

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
cp -r ${GIT_NVIM_DIR} ${CONFIG_DIR}
cp -r ${GIT_RANGER_DIR} ${CONFIG_DIR}

# add aliases
source ${BASH_RC}
