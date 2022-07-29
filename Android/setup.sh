# Reset to clean
clear
cd ~
rm ~/*.sh
rm -rf ~/bin
mkdir ~/bin

# Download main scripts to home folder
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/podcast-downloader.sh
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/music-downloader.sh
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/update-all-packages.sh

# Download yt-dlp URL opener to bin folder
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/termux-url-opener -o ~/bin/termux-url-opener

# Make all scripts executable
chmod +x ~/bin/*.sh
chmod +x ~/*.sh

# Install yt-dlp, FFmpeg and nmap
pkg update -y
pkg upgrade -y
pkg install -y python ffmpeg nmap
yes | pip install yt-dlp

# Setup termux storage
termux-setup-storage