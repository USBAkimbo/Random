clear
echo PKA Downloader
echo
echo Version 2023-04-28
echo

# Variables
dt=$(date +'%Y-%m-%d--%H-%M-%S')

echo ===== Creating temp folder =====
mkdir /storage/emulated/0/Download/podcast-temp-$dt
cd /storage/emulated/0/Download/podcast-temp-$dt

echo ===== Downloading podcast =====
# Get YouTube URL from stdin $1
yt-dlp -f bestaudio $1

echo ===== Processing podcast =====
# Get file name from downloaded file
# For example "PKA 123"
epname=$(echo $(ls) | grep -o -E 'PKN [0-9]{3}|PKA [0-9]{3}')

# Tag podcast name metadata, compress it to 32kbps, change audio channel to mono and output as an MP3
ffmpeg -i * -metadata title="$epname" -metadata artist="PKA" -b:a 32k -ac 1 "$epname.mp3"

echo ===== Moving podcast to podcast folder  =====
mv "$epname.mp3" "/storage/emulated/0/Google Drive/Music/Podcasts/Sync"

echo ===== Deleting temp folder =====
cd ..
rm -rf /storage/emulated/0/Download/podcast-temp-$dt

echo ===== Done! =====
read -p "Press enter to exit"
exit