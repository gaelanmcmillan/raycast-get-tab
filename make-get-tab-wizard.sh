#!/bin/zsh

# This script is a wrapper around the `make-get-tab-script.sh` script.

set -e
setopt extended_glob


BLUE='\033[0;34m'
NC='\033[0m' # no color

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$(dirname "$0")/.raycast-tab-config"
DEFAULT_UTILS_DIR="$HOME/.my-raycast-tools"

# Function to read or create config
get_utils_dir() {
    if [[ -f "$CONFIG_FILE" ]]; then
        UTILS_DIR=$(cat "$CONFIG_FILE")
    else
        echo -e "${BLUE}No configuration found. Let's set up your Raycast tools directory.${NC}"
        echo -e "${BLUE}Default location:${NC} \"$DEFAULT_UTILS_DIR\""

        USE_DEFAULT=""
        while [[ -z $USE_DEFAULT ]]; do
            echo -ne "${BLUE}Use default location? (y/n): ${NC}"
            read USE_DEFAULT
        done

        case "$USE_DEFAULT" in
            [yY])
                UTILS_DIR="$DEFAULT_UTILS_DIR"
                ;;
            *)
                UTILS_DIR=""
                while [[ -z $UTILS_DIR ]]; do
                    echo -ne "${BLUE}Enter your preferred directory path: ${NC}"
                    read UTILS_DIR
                done
                ;;
        esac

        # Create directory if it doesn't exist
        mkdir -p "$UTILS_DIR"

        # Save to config
        echo "$UTILS_DIR" > "$CONFIG_FILE"
        echo -e "${BLUE}Configuration saved to $CONFIG_FILE${NC}"
    fi
}

echo -e "${BLUE}🧙 Welcome to the Raycast \"Get Tab: ___\" Script Command Wizard${NC}"
echo ""
echo "This tool guides you through the process of creating a new Script Command for Raycast that will find or open a Google Chrome tab for you."
echo "Tip: Once you've created your Script Command, you can set a shortcut for it in Raycast."
echo ""

# Get the utils directory from config or prompt user
get_utils_dir

WEBSITE_NAME=""
WARNING=""
while [[ -z $WEBSITE_NAME ]]; do
    echo -ne "${BLUE}Website Name (e.g. \"YouTube Shorts\")${WARNING}: ${NC}"
    read WEBSITE_NAME
    WARNING=" [⚠️ Required]"
done

URL=""
WARNING=""
while [[ -z $URL ]]; do
    echo -ne "${BLUE}Website URL (e.g. \"https://www.youtube.com/shorts\")${WARNING}: ${NC}"
    read URL
    WARNING=" [⚠️ Required]"
done

URL_QUERY=${URL##(#b)http(|s)://} # strip leading http[s]
URL_QUERY=${URL_QUERY%/} # strip trailing slash

CHOICE=""
echo -ne "${BLUE}    Using URL query \"$URL_QUERY\". Ok? (y/n): ${NC}"
read CHOICE

case "$CHOICE" in
    [yY])
        # user accepted the query: no-op
        ;;
    *)
        URL_QUERY=""
        WARNING=""
        while [[ -z $URL_QUERY ]]; do
            echo -ne "${BLUE}Website URL Query (e.g. \"www.youtube.com/shorts\")${WARNING}: ${NC}"
            read URL_QUERY
            WARNING=" [⚠️ Required]"
        done
        ;;
esac

echo -e "${BLUE}🔨 Making ${NC}\"Get Tab: $WEBSITE_NAME\"${BLUE} script in \"$UTILS_DIR\"${NC}"
"${SCRIPT_DIR}"/make-get-tab-script.sh "$UTILS_DIR" "$WEBSITE_NAME" "$URL" "$URL_QUERY"
echo -e "${BLUE}✅ Complete. You now have the Raycast Script Command${NC} \"🌐 Get Tab: $WEBSITE_NAME\"."
