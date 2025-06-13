FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    supervisor \
    wget \
    curl \
    ca-certificates \
    gnupg \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    libgtk-3-0 \
    libasound2 \
    python3 \
    python3-pip \
    git \
    unzip \
    && apt clean

# Install Brave Browser
RUN curl -fsSLo brave.deb https://github.com/YOUR_USERNAME/brave-browser/releases/download/v1.0.0/brave.deb && \
    apt install -y ./brave.deb && \
    rm brave.deb

# Install KasmVNC
RUN curl -fsSLo kasmvnc.tar.gz https://github.com/YOUR_USERNAME/kasmvnc/releases/download/v1.0.0/kasmvnc.tar.gz && \
    mkdir -p /opt/kasmvnc && \
    tar -xzf kasmvnc.tar.gz -C /opt/kasmvnc --strip-components=1 && \
    rm kasmvnc.tar.gz

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Copy supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set entrypoint
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
