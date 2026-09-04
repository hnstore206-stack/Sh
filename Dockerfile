FROM dockurr/windows

# Windows Version: win10 (Tiny10 is sometimes used by dockur for low spec, but default win10 is standard)
# Tiny10 might be lighter, dockur/windows supports "tiny10" as version if we want to be as light as possible.
# Let's use standard win10 to ensure full compatibility unless tiny10 is specifically asked. The user asked for "Win10".
ENV VERSION="win10"

# Resources: Set RAM and CPU. These can be overridden by Railway variables
ENV RAM_SIZE="8G"
ENV CPU_CORES="4"
ENV DISK_SIZE="64G"

# Add our custom startup script for Discord webhooks
COPY start.sh /custom_start.sh
RUN chmod +x /custom_start.sh

# Override the entrypoint to use our script, which then calls the original entrypoint
ENTRYPOINT ["/custom_start.sh"]
