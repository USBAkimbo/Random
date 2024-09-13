clear
echo PKA Downloader
echo
echo Version 2024-09-13
echo

# Variables
tempfolder="/storage/emulated/0/Download/podcast-temp-$(date +'%Y-%m-%d--%H-%M-%S')"
outputfolder="/storage/emulated/0/Data/Google Drive/Music/Podcasts/Sync/"

echo ===== Creating temp folder =====
mkdir -p "$tempfolder"
cd "$tempfolder"

echo ===== Downloading podcast =====
# Get YouTube URL from stdin $1
yt-dlp -f bestaudio --write-info-json $1

echo ===== Extracting upload date =====
# Extract the upload date from the JSON file
upload_date=$(jq -r '.upload_date' *.info.json)
upload_date_formatted=$(date -d "$upload_date" +'%Y-%m-%d')

echo ===== Processing podcast =====
# Get the podcast type from downloaded file
# If the title contains "PKA" or "Already (case insensitive) then set the episode to PKA, otherwise set it to PKN
if ls | grep -qiE 'pka|already'
    then podcast=PKA
    else podcast=PKN
fi

# Set the episode number by getting the first 3 numbers from the file name from the string "$podcast 123"
epnum=$(ls | grep -oiP "$podcast\s*\K\d+")

# Tag podcast name metadata, compress it to 32kbps, change audio channel to mono, set creation date, and output as an MP3
ffmpeg -i * -metadata title="$podcast $epnum" -metadata artist="PKA" -metadata date="$upload_date_formatted" -b:a 32k -ac 1 "$podcast $epnum.mp3"

echo ===== Moving podcast to podcast folder  =====
mv "$podcast $epnum.mp3" "$outputfolder"

echo ===== Deleting temp folder =====
cd ..
rm -rf "$tempfolder"

echo ===== Done! =====
read -p "Press enter to exit"
exit
