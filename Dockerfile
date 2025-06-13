# Base image Ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    x11vnc \
    xvfb \
    net-tools \
    supervisor \
    novnc \
    websockify \
    python3-websockify \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Brave browser
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list && \
    apt-get update && apt-get install -y brave-browser && \
    rm -rf /var/lib/apt/lists/*

# Setup noVNC and VNC server
RUN mkdir -p /etc/supervisor/conf.d

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port for noVNC (default 6080)
EXPOSE 6080

# Create a script to start Xvfb, x11vnc and brave
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
