#!/bin/bash

# Check if file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file-with-domains>"
  exit 1
fi

FILE="$1"

# Loop through each domain in the file
while IFS= read -r DOMAIN; do
  # Skip empty lines
  [ -z "$DOMAIN" ] && continue

  # Fetch and save the output to a file named after the domain
  curl -s "https://www.virustotal.com/vtapi/v2/domain/report?apikey=a0c1542677a3d04f1a78ef06151ba12ea71eb2866714199c47b1a142bca9f309&domain=$DOMAIN" | jq > "vs$DOMAIN.txt"

  echo "    -> Saved data for $DOMAIN to vs$DOMAIN.txt"

  # Wait for 30 seconds before the next request
  sleep 30

done < "$FILE"
