# Update Termux config by pulling from this repo
alias config-update="curl https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/setup.sh | bash"

# Quit by just running "e"
alias e=exit

# Make ll list all files in human readable format
alias ll="ls -lha"

# Get public IP
alias myip="curl ipinfo.io/ip"

# cd to download folder
alias dl="cd /storage/emulated/0/Download"

# Update all packages
alias update-all="pkg update -y && pkg upgrade -y && apt autoremove -y && pip install -U yt-dlp"
