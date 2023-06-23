clear
echo PKA Downloader
echo
echo Version 2023-04-28
echo

# Variables
dt=$(date +'%Y-%m-%d--%H-%M-%S')

echo ===== Creating temp folder =====
mkdir -p /storage/emulated/0/Download/podcast-temp-$dt
cd /storage/emulated/0/Download/podcast-temp-$dt

echo ===== Downloading podcast =====
# Get YouTube URL from stdin $1
yt-dlp -f bestaudio $1

echo ===== Processing podcast =====
# Get the podcast type from downloaded file
# If the title contains "PKA" or "Already" then set the episode to PKA, otherwise set it to PKN
if ls | grep -qiE 'pka|already'
then podcast=PKA
else podcast=PKN
fi

# Set the episode number by getting the first 3 numbers from the file name
epnum=$(ls | grep -oP '^\D*\K\d{3}')

# Tag podcast name metadata, compress it to 32kbps, change audio channel to mono and output as an MP3
ffmpeg -i * -metadata title="$podcast $epnum" -metadata artist="PKA" -b:a 32k -ac 1 "$podcast $epnum.mp3"

echo ===== Moving podcast to podcast folder  =====
mv "$podcast $epnum.mp3" "/storage/emulated/0/Data/Google Drive/Music/Podcasts/Sync"

echo ===== Deleting temp folder =====
cd ..
rm -rf /storage/emulated/0/Download/podcast-temp-$dt

echo ===== Done! =====
read -p "Press enter to exit"
exit
