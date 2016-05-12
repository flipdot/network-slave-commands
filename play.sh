#!/bin/bash
# Uses a video player to stream videos from a website.

player='mpv'

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
re='^https?://[a-z0-9.]+/.*'
if [[ ! "$url" =~ $re ]]; then
    echo 'This does not look like a URL to me.'
    exit 1
fi

# Check for other running players
if [[ $(pgrep -xc "$player") -gt 0 ]]; then
    echo 'Another media player is already running.'
    exit 1
fi

# TODO
# check how to either combine audio/video stream URLs to be streamed at the same time
# OR
# omxplayer already supports URLs on its own with youtube-dl as a backend?

# Try getting raw video's URL
url_video="$(youtube-dl -qg "$url")"
if [[ $? -gt 0 ]]; then
    # No further debugging output needed,
    # because youtube-dl is verbose enough
    exit 1
fi

echo $url_video
mpv "$url_video"
