#!/bin/zsh

# While this script can be used directly, the `make-get-tab-wizard.sh` script is recommended.

RAYCAST_SCRIPT_DIR="$1"
WEBSITE_NAME="$2"
URL="$3"
URL_QUERY="$4"

if [[ -z $RAYCAST_SCRIPT_DIR || -z $WEBSITE_NAME || -z $URL || -z $URL_QUERY ]]; then
  echo "usage: $0 {Script_Directory} {Website_Name} {URL} {URL_Query} "
  echo ""
  echo "{Script_Directory} (e.g. \"~/.my-raycast-tools\"): The path to your raycast scripts directory. This is where this script will generate your new \"get-tab-_.sh\" script."
  echo "{Website Name} (e.g. \"YouTube Shorts\"):          The \"proper name\" of the website. Used to title your generated zsh script and Raycast Script Command."
  echo "{URL} (e.g. \"https://www.youtube.com/shorts\"):   The URL to open when no tab matching the query is found."
  echo "{URL_Query} (e.g. \"youtube.com/shorts\"):         The URL substring to search for when finding an existing tab."
  exit -1
fi

WEBSITE_LOWER="${WEBSITE_NAME:l}"
WEBSITE_KEBAB=$(echo "$WEBSITE_LOWER" | tr -s ' ' | tr ' ' '-')
SCRIPT_NAME="get-tab-${WEBSITE_KEBAB}.sh"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# HACK: Replacing the Raycast annotations with a variable so it doesn't parse THIS script as a Raycast Script Command...
RC="@raycast"

cat << EOF > "$RAYCAST_SCRIPT_DIR/$SCRIPT_NAME"
#!/bin/bash

# Required parameters:
# $RC.schemaVersion 1
# $RC.title Get Tab: ${WEBSITE_NAME}
# $RC.mode silent

# Optional parameters:
# $RC.icon 🌐

# Documentation:
# $RC.description Finds a ${WEBSITE_NAME} tab in Chrome, if one exists, or else makes one.
# $RC.author gmcm
# $RC.authorURL https://github.com/gaelanmcmillan

URL="${URL}"
URL_QUERY="${URL_QUERY}"
osascript "${SCRIPT_DIR}/open-chrome-tab.applescript" \$URL \$URL_QUERY
EOF

