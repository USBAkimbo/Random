clear
echo Podcast Downloader
echo
echo Version Version 2021-02-14
echo

# User input
read -p "Enter the podcast name: " podcast
read -p "Enter the podcast artist: " artist
read -p "Enter the episode number: " epnum
read -p "Paste the YouTube video URL: " youtube

# Create temp folder and cd to it
echo ===== Creating temp folder =====
mkdir /storage/emulated/0/Download/podcast-temp
cd /storage/emulated/0/Download/podcast-temp

# Download video and store it in the podcast-temp folder
echo ===== Downloading podcast =====
youtube-dl -f bestaudio $youtube

# Tag podcast title, episode number, compress it, change audio channel to mono and output as an MP3
echo ===== Processing podcast =====
ffmpeg -i * -metadata title="$podcast $epnum" -metadata artist="$artist" -b:a 32k -ac 1 "$podcast $epnum.mp3"

# Move processed podcast to podcast directory
echo ===== Moving podcast  =====
mv "$podcast $epnum.mp3" /storage/emulated/0/Documents/Podcasts

# Delete temp folder
echo ===== Deleting temp folder =====
cd ..
rm -rf /storage/emulated/0/Download/podcast-temp

# End
echo ===== Done! =====
read -p "Press enter to exit"
exit