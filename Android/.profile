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
alias update-all="pkg update -y && pkg upgrade -y && apt autoremove -y && uv tool upgrade yt-dlp"

# Additional DNS servers
echo "nameserver 10.10.9.1" >> $PREFIX/etc/resolv.conf
echo "nameserver 10.10.9.2" >> $PREFIX/etc/resolv.conf
