source ${CONFIG} || config.txt

# add symbol link to aliases
if [[ ! -L ${ALIAS_FILE} ]]
then
    echo "Symbolic linking bash_aliases to ${ALIAS_FILE} ..."
    ln -s "${DOT_FILES_BASE}/bash_aliases" ${ALIAS_FILE}
fi

# add bash_aliases to .bashrc
if [[ -z $(cat ${BASH_RC} | grep "bash_aliases") ]]
then
    echo "Adding .bash_aliases to .bashrc ..."

    cat << EOF >> ~/.bashrc
# bash aliases definitions
if [[ -f ~/.bash_aliases ]]
then
    source ~/.bash_aliases
fi
EOF
fi

# add aliases
source ${BASH_RC}

# install useful programs
sudo apt install neovim ntfs-3g -y
