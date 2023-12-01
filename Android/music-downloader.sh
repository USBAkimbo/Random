clear
echo Music Downloader
echo
echo Version 2022-07-01
echo

# Create temp folder and cd to it
echo ===== Creating temp folder =====
mkdir -p ~/Download/music-temp
cd ~/Download/music-temp

# Download song to temp folder from stdin
echo ===== Downloading song =====
yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 --add-metadata --embed-thumbnail -o "%(artist)s - %(title)s.%(ext)s" $1

# Move song to music directory with new name
echo ===== Moving song to ~/Download =====
mv * "~/Download"

# Delete temp folder
echo ===== Deleting temp folder =====
cd ..
rm -rf ~/Download/music-temp

# End
echo ===== Done! =====
read -p "Press enter to exit"
exit
