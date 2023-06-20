clear
echo Music Downloader
echo
echo Version 2022-07-01
echo

# User input
read -p "Paste the YouTube Music URL: " youtube

# Create temp folder and cd to it
echo ===== Creating temp folder =====
mkdir -p /storage/emulated/0/Download/music-temp
cd /storage/emulated/0/Download/music-temp

# Download song to temp folder
echo ===== Downloading song =====
yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 --add-metadata --embed-thumbnail -o "%(artist)s - %(title)s.%(ext)s" $youtube

# Move song to music directory with new name
echo ===== Moving song =====
mv * "/storage/emulated/0/Google Drive/Music/Songs"

# Delete temp folder
echo ===== Deleting temp folder =====
cd ..
rm -rf /storage/emulated/0/Download/music-temp

# End
echo ===== Done! =====
read -p "Press enter to exit"
exit
