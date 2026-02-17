#!/bin/bash

clear
echo PKA Downloader
echo
echo Version 2025-02-17
echo

# Variables
FEED_URL="https://feed.podbean.com/painkilleralready/feed.xml"
TEMP_FOLDER="/storage/emulated/0/Download/podcast-temp-$(date +'%Y-%m-%d--%H-%M-%S')"
OUTPUT_FOLDER="/storage/emulated/0/Sync/Music/Podcasts/PKA"
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"

# Ensure output folder exists
mkdir -p "$OUTPUT_FOLDER"

# Function to send Discord notification
send_discord_notification() {
    local message="$1"
    if [ -n "$DISCORD_WEBHOOK_URL" ]; then
        # Use jq to properly escape the message for JSON
        if command -v jq >/dev/null 2>&1; then
            local payload=$(jq -n --arg msg "$message" '{content: $msg}')
            curl -H "Content-Type: application/json" \
                 -X POST \
                 -d "$payload" \
                 "$DISCORD_WEBHOOK_URL" 2>/dev/null
        else
            # Fallback: basic escaping if jq is not available
            local escaped_msg=$(echo "$message" | sed 's/"/\\"/g' | sed 's/\\/\\\\/g')
            curl -H "Content-Type: application/json" \
                 -X POST \
                 -d "{\"content\": \"$escaped_msg\"}" \
                 "$DISCORD_WEBHOOK_URL" 2>/dev/null
        fi
    fi
}

# Function to extract episode number from title
extract_episode_number() {
    local title="$1"
    # Try to extract PKN followed by number first
    if echo "$title" | grep -qiE 'PKN'; then
        echo "$title" | grep -oiP 'PKN\s*\K\d+' || echo ""
    # Then try PKA followed by number
    elif echo "$title" | grep -qiE 'PKA'; then
        echo "$title" | grep -oiP 'PKA\s*\K\d+' || echo ""
    # Try to extract just a number (for "Painkiller Already 733" format)
    else
        echo "$title" | grep -oP '\d+' | head -1 || echo ""
    fi
}

# Function to determine podcast type
get_podcast_type() {
    local title="$1"
    if echo "$title" | grep -qiE 'PKN'; then
        echo "PKN"
    else
        echo "PKA"
    fi
}

# Function to check if episode already exists
episode_exists() {
    local podcast_type="$1"
    local episode_num="$2"
    if [ -f "$OUTPUT_FOLDER/$podcast_type $episode_num.mp3" ]; then
        return 0
    else
        return 1
    fi
}

# Function to download and process episode
download_episode() {
    local title="$1"
    local audio_url="$2"
    local pub_date="$3"
    
    local podcast_type=$(get_podcast_type "$title")
    local episode_num=$(extract_episode_number "$title")
    
    if [ -z "$episode_num" ]; then
        echo "Warning: Could not extract episode number from '$title', skipping..."
        return 1
    fi
    
    if episode_exists "$podcast_type" "$episode_num"; then
        echo "Episode $podcast_type $episode_num already exists, skipping..."
        return 0
    fi
    
    echo "Downloading $podcast_type $episode_num..."
    
    # Create temp folder
    mkdir -p "$TEMP_FOLDER"
    cd "$TEMP_FOLDER"
    
    # Download the audio file
    local temp_file="temp_audio.mp3"
    if ! wget -q -O "$temp_file" "$audio_url"; then
        echo "Error: Failed to download episode"
        cd ..
        rm -rf "$TEMP_FOLDER"
        return 1
    fi
    
    # Convert pub_date to ISO 8601 format
    # Typical RSS pubDate format: "Wed, 15 Jan 2025 12:00:00 +0000"
    local upload_date_iso8601=$(date -d "$pub_date" --iso-8601=seconds 2>/dev/null || echo "$pub_date")
    
    # Process with ffmpeg: add metadata, compress, convert to mono
    if ! ffmpeg -y -i "$temp_file" \
         -metadata title="$podcast_type $episode_num" \
         -metadata artist="PKA" \
         -metadata date="$upload_date_iso8601" \
         -b:a 32k -ac 1 \
         "$podcast_type $episode_num.mp3" >/dev/null 2>&1; then
        echo "Error: Failed to process episode with ffmpeg"
        cd ..
        rm -rf "$TEMP_FOLDER"
        return 1
    fi
    
    # Move to output folder
    mv "$podcast_type $episode_num.mp3" "$OUTPUT_FOLDER/"
    
    # Clean up temp folder
    cd ..
    rm -rf "$TEMP_FOLDER"
    
    echo "Successfully downloaded and processed $podcast_type $episode_num"
    send_discord_notification "📥 Downloaded new PKA episode: **$podcast_type $episode_num** - $title"
    
    return 0
}

echo ===== Fetching podcast feed =====
# Download the XML feed
FEED_FILE="/tmp/pka-feed-$(date +'%Y%m%d%H%M%S').xml"
if ! wget -q -O "$FEED_FILE" "$FEED_URL"; then
    echo "Error: Failed to download podcast feed"
    exit 1
fi

echo ===== Checking for new episodes =====

# Parse XML and process episodes
# Extract all items from the feed (most recent first)
downloaded_count=0

# Use a temporary file to track downloads since the while loop runs in a subshell
DOWNLOAD_LOG="/tmp/pka-downloads-$(date +'%Y%m%d%H%M%S').log"
> "$DOWNLOAD_LOG"  # Create empty file

# Use xmllint or grep/sed to parse XML
# We'll use a simple approach with grep and sed since xmllint might not be available
# Extract each <item> block and process it
awk '/<item>/,/<\/item>/' "$FEED_FILE" | while IFS= read -r line; do
    # Collect lines until we have a complete item
    if [[ "$line" == *"<item>"* ]]; then
        item_content="$line"
    elif [[ "$line" == *"</item>"* ]]; then
        item_content="$item_content$line"
        
        # Extract title (handles both plain text and CDATA)
        title=$(echo "$item_content" | sed -n 's/.*<title[^>]*>\s*\(<!\[CDATA\[\)\?\s*\([^]<]*\)\s*\(\]\]>\)\?\s*<\/title>.*/\2/p' | head -1)
        # Fallback to simpler pattern if CDATA pattern didn't match
        if [ -z "$title" ]; then
            title=$(echo "$item_content" | sed -n 's/.*<title[^>]*>\([^<]*\)<\/title>.*/\1/p' | head -1)
        fi
        
        # Extract enclosure URL (audio file)
        audio_url=$(echo "$item_content" | sed -n 's/.*url="\([^"]*\)".*/\1/p' | head -1)
        
        # Extract pubDate (matches first occurrence only)
        pub_date=$(echo "$item_content" | sed -n 's/.*<pubDate[^>]*>\([^<]*\)<\/pubDate>.*/\1/p' | head -1)
        
        # Process if we have all required fields
        if [ -n "$title" ] && [ -n "$audio_url" ] && [ -n "$pub_date" ]; then
            download_episode "$title" "$audio_url" "$pub_date"
            if [ $? -eq 0 ]; then
                echo "1" >> "$DOWNLOAD_LOG"
            fi
        fi
        
        item_content=""
    else
        item_content="$item_content$line"
    fi
done

# Count successful downloads
downloaded_count=$(wc -l < "$DOWNLOAD_LOG" 2>/dev/null || echo 0)

# Clean up feed file and download log
rm -f "$FEED_FILE"
rm -f "$DOWNLOAD_LOG"

echo
echo ===== Done! =====
echo "Downloaded $downloaded_count new episode(s)"
send_discord_notification "✅ PKA Downloader completed: $downloaded_count new episode(s) downloaded"

# Only pause if running interactively
if [ -t 0 ]; then
    read -p "Press enter to exit"
fi
exit
