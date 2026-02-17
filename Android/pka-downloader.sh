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

echo ===== Fetching podcast feed =====
# Download the XML feed
FEED_FILE="/tmp/pka-feed-$(date +'%Y%m%d%H%M%S').xml"
if ! wget -q -O "$FEED_FILE" "$FEED_URL"; then
    echo "Error: Failed to download podcast feed"
    exit 1
fi

echo ===== Checking for new episodes =====

# Track downloads
downloaded_count=0

# Extract each <item> block and process it
awk '/<item>/,/<\/item>/' "$FEED_FILE" | while IFS= read -r line; do
    # Collect lines until we have a complete item
    if [[ "$line" == *"<item>"* ]]; then
        item_content="$line"
    elif [[ "$line" == *"</item>"* ]]; then
        item_content="$item_content$line"
        
        # Extract title (handles both plain text and CDATA)
        title=$(echo "$item_content" | sed -n 's/.*<title[^>]*>\s*\(<!\[CDATA\[\)\?\s*\([^]<]*\)\s*\(\]\]>\)\?\s*<\/title>.*/\2/p' | head -1)
        if [ -z "$title" ]; then
            title=$(echo "$item_content" | sed -n 's/.*<title[^>]*>\([^<]*\)<\/title>.*/\1/p' | head -1)
        fi
        
        # Extract enclosure URL (audio file)
        audio_url=$(echo "$item_content" | sed -n 's/.*url="\([^"]*\)".*/\1/p' | head -1)
        
        # Extract pubDate
        pub_date=$(echo "$item_content" | sed -n 's/.*<pubDate[^>]*>\([^<]*\)<\/pubDate>.*/\1/p' | head -1)
        
        # Process if we have all required fields
        if [ -n "$title" ] && [ -n "$audio_url" ] && [ -n "$pub_date" ]; then
            # Determine podcast type (PKA or PKN)
            if echo "$title" | grep -qiE 'PKN'; then
                PODCAST=PKN
            else
                PODCAST=PKA
            fi
            
            # Get the episode number
            if echo "$title" | grep -qiE 'PKN'; then
                EP_NUM=$(echo "$title" | grep -oiP 'PKN\s*\K\d+' || echo "")
            elif echo "$title" | grep -qiE 'PKA'; then
                EP_NUM=$(echo "$title" | grep -oiP 'PKA\s*\K\d+' || echo "")
            else
                # Fallback: extract first number
                EP_NUM=$(echo "$title" | grep -oP '\d+' | head -1 || echo "")
            fi
            
            # Skip if we couldn't extract episode number
            if [ -z "$EP_NUM" ]; then
                echo "Warning: Could not extract episode number from '$title', skipping..."
            elif [ -f "$OUTPUT_FOLDER/$PODCAST $EP_NUM.mp3" ]; then
                echo "Episode $PODCAST $EP_NUM already exists, skipping..."
            else
                echo "Downloading $PODCAST $EP_NUM..."
                
                # Create temp folder
                mkdir -p "$TEMP_FOLDER"
                cd "$TEMP_FOLDER"
                
                # Download the audio file
                if wget -q -O "temp_audio.mp3" "$audio_url"; then
                    # Convert pub_date to ISO 8601 format
                    UPLOAD_DATE_ISO8601=$(date -d "$pub_date" --iso-8601=seconds 2>/dev/null || echo "$pub_date")
                    
                    # Process with ffmpeg: add metadata, compress, convert to mono
                    if ffmpeg -y -i "temp_audio.mp3" \
                         -metadata title="$PODCAST $EP_NUM" \
                         -metadata artist="PKA" \
                         -metadata date="$UPLOAD_DATE_ISO8601" \
                         -b:a 32k -ac 1 \
                         "$PODCAST $EP_NUM.mp3" >/dev/null 2>&1; then
                        
                        # Move to output folder
                        mv "$PODCAST $EP_NUM.mp3" "$OUTPUT_FOLDER/"
                        
                        echo "Successfully downloaded and processed $PODCAST $EP_NUM"
                        
                        # Send Discord notification
                        if [ -n "$DISCORD_WEBHOOK_URL" ]; then
                            if command -v jq >/dev/null 2>&1; then
                                payload=$(jq -n --arg msg "Downloaded new episode: $PODCAST $EP_NUM" '{content: $msg}')
                                curl -H "Content-Type: application/json" -X POST -d "$payload" "$DISCORD_WEBHOOK_URL" 2>/dev/null
                            else
                                curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"Downloaded new episode: $PODCAST $EP_NUM\"}" "$DISCORD_WEBHOOK_URL" 2>/dev/null
                            fi
                        fi
                        
                        downloaded_count=$((downloaded_count + 1))
                    else
                        echo "Error: Failed to process episode with ffmpeg"
                    fi
                else
                    echo "Error: Failed to download episode"
                fi
                
                # Clean up temp folder
                cd ..
                rm -rf "$TEMP_FOLDER"
            fi
        fi
        
        item_content=""
    else
        item_content="$item_content$line"
    fi
done

# Clean up feed file
rm -f "$FEED_FILE"

echo
echo ===== Done! =====
echo "Downloaded $downloaded_count new episode(s)"

# Send completion notification
if [ -n "$DISCORD_WEBHOOK_URL" ] && [ $downloaded_count -gt 0 ]; then
    if command -v jq >/dev/null 2>&1; then
        payload=$(jq -n --arg msg "PKA Downloader completed: $downloaded_count new episode(s) downloaded" '{content: $msg}')
        curl -H "Content-Type: application/json" -X POST -d "$payload" "$DISCORD_WEBHOOK_URL" 2>/dev/null
    else
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"PKA Downloader completed: $downloaded_count new episode(s) downloaded\"}" "$DISCORD_WEBHOOK_URL" 2>/dev/null
    fi
fi

# Only pause if running interactively
if [ -t 0 ]; then
    read -p "Press enter to exit"
fi
exit
