clear
echo PKA Downloader
echo
echo Version 2024-07-13
echo

# Variables
dt=$(date +'%Y-%m-%d--%H-%M-%S')
tempfolder="/storage/emulated/0/Download/podcast-temp-$dt"
outputfolder="/storage/emulated/0/Data/Google Drive/Music/Podcasts/Sync/"

echo ===== Creating temp folder =====
mkdir -p $tempfolder
cd $tempfolder

echo ===== Downloading podcast =====
# Get YouTube URL from stdin $1
yt-dlp -f bestaudio $1

echo ===== Processing podcast =====
# Get the podcast type from downloaded file
# If the title contains "PKA" or "Already (case insensitive) then set the episode to PKA, otherwise set it to PKN
if ls | grep -qiE 'pka|already'
    then podcast=PKA
    else podcast=PKN
fi

# Set the episode number by getting the first 3 numbers from the file name from the string "$podcast 123"
epnum=$(ls | grep -oiP "$podcast\s*\K\d+")

# Tag podcast name metadata, compress it to 32kbps, change audio channel to mono and output as an MP3
ffmpeg -i * -metadata title="$podcast $epnum" -metadata artist="PKA" -b:a 32k -ac 1 "$podcast $epnum.mp3"

echo ===== Moving podcast to podcast folder  =====
mv "$podcast $epnum.mp3" $outputfolder

echo ===== Deleting temp folder =====
cd ..
rm -rf $tempfolder

echo ===== Done! =====
read -p "Press enter to exit"
exit
