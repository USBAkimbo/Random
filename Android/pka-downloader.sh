clear
echo PKA Downloader
echo
echo Version 2024-10-23
echo

# Variables
TEMP_FOLDER="/storage/emulated/0/Download/podcast-temp-$(date +'%Y-%m-%d--%H-%M-%S')"
OUTPUT_FOLDER="/storage/emulated/0/Sync/Music/Podcasts/PKA"

echo ===== Creating temp folder =====
mkdir -p "$TEMP_FOLDER"
cd "$TEMP_FOLDER"

echo ===== Downloading podcast =====
# Get YouTube URL from stdin $1
yt-dlp -f bestaudio --write-info-json $1

echo ===== Extracting upload date =====
# Extract the unix timestamp upload date and convert to ISO 8601 date format
TIMESTAMP=$(jq -r '.timestamp' *.info.json)
UPLOAD_DATE_ISO8601=$(date -d "@$TIMESTAMP" --iso-8601=seconds)

echo ===== Processing podcast =====
# Get the podcast type from json metadata
# If the title contains "PKA" or "Already" (case insensitive) then set the episode to PKA, otherwise set it to PKN
PODCAST_CHECK=$(jq -r '.title' *.json)

if echo $PODCAST_CHECK | grep -qiE 'pka|already'
    then PODCAST=PKA
    else PODCAST=PKN
fi

# Get the episode number by finding the first 3 numbers after the $PODCAST name"
EP_NUM=$(echo $PODCAST_CHECK | grep -oiP "$PODCAST\s*\K\d+")

# Get the file name
FILENAME=$(ls --ignore=*.json)

# Tag podcast name metadata
# Set the file creation date to the upload date and time
# Compress podcast to 32kbps
# Change audio channel to mono
# Output as an MP3
ffmpeg -i "$FILENAME" -metadata title="$PODCAST $EP_NUM" -metadata artist="PKA" -metadata date="$UPLOAD_DATE_ISO8601" -b:a 32k -ac 1 "$PODCAST $EP_NUM.mp3"

echo ===== Moving podcast to podcast folder  =====
mv "$PODCAST $EP_NUM.mp3" "$OUTPUT_FOLDER"

echo ===== Deleting temp folder =====
cd ..
rm -rf "$TEMP_FOLDER"

echo ===== Done! =====
read -p "Press enter to exit"
exit
