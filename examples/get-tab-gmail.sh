#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get Tab: Gmail
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Finds a Gmail tab in Chrome, if one exists, or else makes one.
# @raycast.author gmcm
# @raycast.authorURL https://github.com/gaelanmcmillan

URL="https://mail.google.com/"
URL_QUERY="mail.google.com"
osascript ../open-chrome-tab.applescript $URL $URL_QUERY
