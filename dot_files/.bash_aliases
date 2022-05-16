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
alias gcode="cd ${GIT_BASE}/coding_challenges"
alias gexpense="cd ${GIT_BASE}/expense_report"
alias gwebs="cd ${GIT_BASE}/web_scrapers"

# shred in parallel command
alias Shred="nice -n 19 /usr/local/bin/ruby ~/git_projects/scripts/ruby/executables/shred.rb"
alias ruby="/usr/local/bin/ruby"

# sqlite
alias sqlitestudio='/opt/SQLiteStudio/sqlitestudio'
alias sqlstudio=sqlitestudio

# youtube
alias yt="yt-dlp --format best -ic" # Download video link
alias yta="yt -x -f bestaudio/best" # Download only audio
alias YT="youtube-viewer"

# Sony Vaio
alias lights_on='echo 1 | sudo tee /sys/devices/platform/sony-laptop/kbd_backlight'
alias lights_off='echo 0 | sudo tee /sys/devices/platform/sony-laptop/kbd_backlight'

# PI ssh
alias pissh='ssh ubuntu@192.168.1.81'

alias qmv='qmv -e nvim -o width=85,spaces'
