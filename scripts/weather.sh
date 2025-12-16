#!/bin/bash

# Weather Fetch Script (No Icons, Pure Text)
OUTPUT_FILE="/tmp/weather.json"
CACHE_FILE="/tmp/.weather_cache_text.json"

# Update every 30 minutes
if [ -f "$CACHE_FILE" ]; then
    current_time=$(date +%s)
    file_time=$(stat -c %Y "$CACHE_FILE")
    age=$((current_time - file_time))
    if [ $age -lt 1800 ] && [ -s "$CACHE_FILE" ]; then
        cp "$CACHE_FILE" "$OUTPUT_FILE"
        exit 0
    fi
fi

get_weather() {
    local city=$1
    # Use format %C_%t_%w (Condition, Temp, Wind)
    raw_data=$(curl -s "wttr.in/$city?format=%C_%t_%w&m")
    
    IFS='_' read -r cond temp wind <<< "$raw_data"
    
    # Clean wind arrows
    clean_wind=$(echo "$wind" | sed 's/[^a-zA-Z0-9/]//g') 
    
    # Output: Condition Temp Wind (No Icon)
    # The user complained about messy code "after cancelling the city", which likely meant the icon.
    # So we just print the text data.
    # Alignment: 
    # Hefei: Clear +12C 8km/h
    echo "$cond $temp $clean_wind"
}

hefei=$(get_weather "Hefei")
luoyang=$(get_weather "Luoyang")
wuxi=$(get_weather "Wuxi")

if [ -z "$hefei" ]; then
    exit 1
fi

cat <<EOF > "$CACHE_FILE"
Hefei: $hefei
Luoyang: $luoyang
Wuxi: $wuxi
EOF

cp "$CACHE_FILE" "$OUTPUT_FILE"
