clear
echo PKA Downloader
echo
echo Version 2022-02-11
echo

# User input
read -p "Enter the podcast name (PKA or PKN): " podcast
read -p "Enter the episode number: " epnum
read -p "Paste the YouTube video URL: " youtube

# Create temp folder and cd to it
echo ===== Creating temp folder =====
mkdir /storage/emulated/0/Download/podcast-temp-$epnum
cd /storage/emulated/0/Download/podcast-temp-$epnum

# Download video and store it in the podcast-temp folder
echo ===== Downloading podcast =====
yt-dlp -f bestaudio $youtube

# Tag podcast name, episode number, compress it to 32kbps, change audio channel to mono and output as an MP3
echo ===== Processing podcast =====
ffmpeg -i * -metadata title="$podcast $epnum" -metadata artist="PKA" -b:a 32k -ac 1 "$podcast $epnum.mp3"

# Move processed podcast to podcast directory
echo ===== Moving podcast  =====
mv "$podcast $epnum.mp3" "/storage/emulated/0/Google Drive/Music/Podcasts/Sync"

# Delete temp folder
echo ===== Deleting temp folder =====
cd ..
rm -rf /storage/emulated/0/Download/podcast-temp-$epnum

# End
echo ===== Done! =====
read -p "Press enter to exit"
exit