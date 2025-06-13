FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    sudo curl unzip wget gnupg2 software-properties-common \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdbus-1-3 libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 libgtk-3-0 \
    libxss1 libxtst6 x11-utils \
    xfce4 xfce4-goodies xterm dbus-x11 \
    supervisor

# Install Brave Browser (Windows .exe not supported natively, install Linux version instead)
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave.com/static-assets/keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list && \
    apt update && apt install -y brave-browser

# Add KasmVNC
COPY kasm_release.zip /opt/kasm_release.zip
RUN unzip /opt/kasm_release.zip -d /opt/kasm && \
    chmod +x /opt/kasm/*.sh

# Set up kasm user and environment
RUN useradd -m kasm && \
    echo "kasm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Run kasm in supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6901
CMD ["/usr/bin/supervisord", "-n"]
