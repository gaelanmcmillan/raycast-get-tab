-- This script is a generic utility for managing Chrome tabs through Raycast.
-- It takes two arguments:
--   1. targetUrl: The full URL to open if no matching tab is found
--   2. query: The URL fragment to search for in existing tabs
--
-- The script will:
--   1. Check if Chrome is running, launch it if not
--   2. Search all Chrome windows and tabs for the given query
--   3. If a matching tab is found, activate it and bring it to front
--   4. If no matching tab is found, create a new tab with the target URL
--
-- Usage example:
--   osascript open-chrome-tab.applescript "https://github.com" "github.com"
--
-- This script is designed to be called by Raycast script commands that manage
-- specific websites, providing a consistent way to find or create tabs.

on run argv
    if (count of argv) is not 2 then
        display dialog "Expected two arguments: url and urlQuery"
        return
    end if

    set targetUrl to item 1 of argv
    set query to item 2 of argv

    -- Launch Chrome if not running
    tell application "System Events"
        if not (exists process "Google Chrome") then
            tell application "Google Chrome" to activate
            display notification "Opening Google Chrome" with title "Chrome Script"
            delay 1 -- wait briefly for launch
        end if
    end tell

    -- Search for existing tab with query
    set foundTab to false

    tell application "Google Chrome"
        set windowList to every window
        set winIndex to 1

        repeat with w in windowList
            set tabList to every tab of w
            set tabIndex to 1

            repeat with t in tabList
                if (URL of t contains query) then
                    set active tab index of window winIndex to tabIndex
                    set index of window winIndex to 1
                    activate
                    set foundTab to true
                    exit repeat
                end if
                set tabIndex to tabIndex + 1
            end repeat

            if foundTab then exit repeat
            set winIndex to winIndex + 1
        end repeat

        -- If no existing tabs contain the URL query, make one.
        if not foundTab then
            if (count of windows) is 0 then
                make new window
            end if

            tell window 1
                set newTab to make new tab at end of tabs with properties {URL:targetUrl}
                set active tab index to (count of tabs)
            end tell

            activate
        end if
    end tell

end run
