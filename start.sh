#!/bin/sh

# Ensure script doesn't crash from DOS line endings (if somehow present)
# Function to send Discord webhook
send_webhook() {
    local message="$1"
    local webhook_url="https://discord.com/api/webhooks/1545318138420142103/vZF1XSpXzjWr2PZexn-bOD0bznBxZSVwcZWvSCaaOwv-KKUyds9tU41vMaDXnJKwuuKn"
    
    # Send using curl
    curl -s -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" "$webhook_url" > /dev/null 2>&1
}

# Construct connection info
if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
    DOMAIN="$RAILWAY_PUBLIC_DOMAIN"
elif [ -n "$RAILWAY_STATIC_URL" ]; then
    DOMAIN="$RAILWAY_STATIC_URL"
else
    DOMAIN="No public domain found. Please generate one in Railway Networking settings."
fi

START_MESSAGE="🟢 **Windows 10 VPS is starting up on Railway!**\n\n🌐 **Connection Info:**\n- **Web UI:** https://$DOMAIN\n- **RDP:** (If you have a TCP proxy on port 3389)"

# Send start message
send_webhook "$START_MESSAGE"

# Setup trap to catch stop signals
cleanup() {
    send_webhook "🔴 **Windows 10 VPS is stopping or restarting...**"
    if [ -n "$child" ]; then
        kill -TERM "$child" 2>/dev/null
    fi
    exit 0
}

trap cleanup TERM INT QUIT

# Run the original dockur/windows entrypoint in the background
/usr/bin/tini -s -- /run/entry.sh &
child=$!

# Wait for the child process to exit
wait "$child"
