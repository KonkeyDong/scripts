source ${CONFIG} || source config.txt

# dealing with the alias file itself
alias jal="source ${BASH_RC}" # re-source
alias jalv="vim ${BASH_ALIASES}"
alias jall="less ${BASH_ALIASES}"

# update system & auto remove old junk
alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove'

# git project dir
alias groot="cd ${GIT_BASE}"
alias gscripts="cd ${GIT_BASE}/scripts"

# shred in parallel command
alias Shred="nice -n 19 /usr/bin/ruby ~/git_projects/scripts/ruby/Executables/shred.rb"

# sqlite
alias sqlitestudio='/opt/SQLiteStudio/sqlitestudio'
alias sqlstudio=sqlitestudio

# youtube
alias yt="youtube-dl --add-metadata -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer"