#!/bin/bash
# Opens a URL in a new browser window

play='play'
browser='chromium'
browser_options='--disable-translate --kiosk --incognito --disable-tab-switcher'

print_usage() {
    echo 'Usage:'
    echo "$(basename $0) URL"
}

# Validate parameter count
if [[ $# -ne 1 ]]; then
    print_usage
    exit 1
fi

# Validate URL
url="$1"
re='^(https?://)?[a-z0-9.]+(/.*)?'
if [[ ! "$url" =~ $re ]]; then
    echo 'This does not look like a URL to me.'
    exit 1
fi

# Check whether URL contains a video
# and use 'play' instead then
youtube-dl -sq "$url" &>/dev/null
if [[ ! $? -gt 0 ]]; then
    "$play" "$url"
    exit 0
fi

# TODO
# Make chromium use only a single tab and don't open tabs in the
# background

# Kill browser if tab is already open
if [[ $(pgrep -xc "$browser") -gt 0 ]]; then
    killall "$browser"
fi

"$browser" $browser_options "$url" &>/dev/null &
