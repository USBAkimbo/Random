# Reset to clean
clear
cd ~
rm -f podcast-downloader.sh
rm -f pka-downloader.sh
rm -f music-downloader.sh
rm -f update-all-packages.sh
rm -f .profile*
rm -rf ~/bin
mkdir ~/bin

# Download main scripts to home folder
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/pka-downloader.sh
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/music-downloader.sh
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/update-all-packages.sh
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/.profile
wget https://raw.githubusercontent.com/USBAkimbo/Random/master/Android/termux-url-opener

# Move termux-url-opener to bin folder
mv termux-url-opener ~/bin/termux-url-opener

# Make all scripts executable
chmod +x ~/bin/termux-url-opener
chmod +x *.sh

# Install yt-dlp, FFmpeg and nmap
pkg update -y
pkg upgrade -y
pkg install -y python ffmpeg nmap
yes | pip install yt-dlp

# Setup termux storage
termux-setup-storage
