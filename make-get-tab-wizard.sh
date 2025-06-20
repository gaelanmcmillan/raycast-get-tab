#!/bin/zsh

# This script is a wrapper around the `make-get-tab-script.sh` script.

set -e
setopt extended_glob


BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # no color
INDENT="    "

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$(dirname "$0")/.raycast-tab-config"
DEFAULT_UTILS_DIR="$HOME/.my-raycast-tools"

# Persistently read a required variable.
read_required() {
  local prompt="$1"
  local resp=""
  local warning=""

  while [[ -z $resp ]]; do
    echo -ne "${BLUE}${prompt}:${warning} ${NC}" > /dev/tty
    read resp < /dev/tty
    warning=" [⚠️  Required]"
  done

  echo "$resp"
}

# Function to read or create config
get_utils_dir() {
    if [[ -f "$CONFIG_FILE" ]]; then
        UTILS_DIR=$(cat "$CONFIG_FILE")
    else
        echo -e "${BLUE}No configuration found. Let's set up your Raycast tools directory.${NC}"
        echo -e "${BLUE}${INDENT}Default location:${NC} \"$DEFAULT_UTILS_DIR\""

        echo -ne "${BLUE}${INDENT}Use default location? (y/n): ${NC}"
        read USE_DEFAULT

        case "$USE_DEFAULT" in
            [yY])
                UTILS_DIR="$DEFAULT_UTILS_DIR"
                ;;
            *)
                echo -e "${RED}${INDENT}Note: don't use \"~\", \"\$HOME\" or any other environment variables in the path you enter.${NC}"
                PROMPT="${INDENT}Enter your preferred directory path (e.g. \"/Users/<your-name>/.my-raycast-tools\")"
                WARNING=""
                UTILS_DIR=""
                while [[ -z $UTILS_DIR || $UTILS_DIR == "~"* || $UTILS_DIR == *\$* ]]; do
                    echo -ne "${BLUE}${PROMPT}:${WARNING} ${NC}"
                    read UTILS_DIR
                    if [[ -z $UTILS_DIR ]]; then
                        WARNING=" [⚠️  Required]"
                    fi

                    if [[ $UTILS_DIR == "~"* || $UTILS_DIR == *\$* ]]; then
                        WARNING=" [⚠️ \"~\" and \"\$\" are disallowed]"
                    fi
                done
                ;;
        esac

        # Create directory if it doesn't exist
        mkdir -p "$UTILS_DIR"

        # Save to config
        echo "$UTILS_DIR" > "$CONFIG_FILE"
        echo -e "${BLUE}${INDENT}Configuration saved to ${NC}\"$CONFIG_FILE\""
    fi
}

echo -e "${BLUE}🧙 Welcome to the Raycast \"Get Tab\" Script Command Wizard${NC}"
echo ""
echo "This tool guides you through the process of creating a new Script Command for Raycast that will find or open a Google Chrome tab for you."
echo "Tip: Once you've created your Script Command, you can set a shortcut for it in Raycast."
echo ""

# Get the utils directory from config or prompt user
get_utils_dir

WEBSITE_NAME=$(read_required "Website Name (e.g. \"YouTube Shorts\")")
URL=$(read_required "Website URL (e.g. \"https://www.youtube.com/shorts\")")
URL_QUERY=${URL##(#b)http(|s)://} # strip leading http[s]
URL_QUERY=${URL_QUERY%/} # strip trailing slash

echo -ne "${BLUE}${INDENT}Using URL query ${NC}\"$URL_QUERY\"${BLUE}. Ok? (y/n): ${NC}"
read CHOICE

case "$CHOICE" in
    [yY])
        # user accepted the query: no-op
        ;;
    *)
        URL_QUERY=$(read_required "Website URL Query (e.g. \"www.youtube.com/shorts\")")
        ;;
esac

echo -e "${BLUE}🔨 Making ${NC}\"Get Tab: $WEBSITE_NAME\"${BLUE} script in \"$UTILS_DIR\"${NC}"
"${SCRIPT_DIR}"/make-get-tab-script.sh "$UTILS_DIR" "$WEBSITE_NAME" "$URL" "$URL_QUERY"
echo -e "${BLUE}✅ Complete. You now have the Raycast Script Command${NC} \"🌐 Get Tab: $WEBSITE_NAME\"."
echo ""
echo -e "${RED}❗ Don't forget to add \"${UTILS_DIR}\" to your list of Raycast Script Commands directories!"
