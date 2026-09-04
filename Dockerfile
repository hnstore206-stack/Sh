FROM dockurr/windows

# Windows Version: win10 (Tiny10 is sometimes used by dockur for low spec, but default win10 is standard)
# Tiny10 might be lighter, dockur/windows supports "tiny10" as version if we want to be as light as possible.
# Let's use standard win10 to ensure full compatibility unless tiny10 is specifically asked. The user asked for "Win10".
ENV VERSION="win10"

# Resources: Set RAM and CPU. These can be overridden by Railway variables
# Lowered RAM to 4G to prevent Railway OOM Kill (Crash loops causing webhook spam)
ENV RAM_SIZE="4G"
ENV CPU_CORES="2"
ENV DISK_SIZE="32G"

# Add our custom startup script for Discord webhooks
RUN mkdir -p /storage
COPY start.sh /custom_start.sh
RUN chmod +x /custom_start.sh && sed -i 's/\r$//' /custom_start.sh

# Override the entrypoint to use our script, which then calls the original entrypoint
ENTRYPOINT ["/custom_start.sh"]
