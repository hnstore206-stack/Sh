#!/bin/sh

# Function to send Discord webhook
send_webhook() {
    local message="$1"
    local webhook_url="https://discord.com/api/webhooks/1545318138420142103/vZF1XSpXzjWr2PZexn-bOD0bznBxZSVwcZWvSCaaOwv-KKUyds9tU41vMaDXnJKwuuKn"
    curl -s -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" "$webhook_url" > /dev/null 2>&1
}

# Send start message
send_webhook "🟢 Windows 10 VPS is starting up on Railway..."

# Setup trap to catch stop signals
cleanup() {
    send_webhook "🔴 Windows 10 VPS is stopping or restarting..."
    # Kill the background entry process
    if [ -n "$child" ]; then
        kill -TERM "$child" 2>/dev/null
    fi
    exit 0
}

trap cleanup TERM INT QUIT

# Run the original dockur/windows entrypoint in the background
# dockur/windows normally uses tini as its entrypoint, we do the same
/usr/bin/tini -s -- /run/entry.sh &
child=$!

# Wait for the child process to exit
wait "$child"
