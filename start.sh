#!/bin/bash
export DISPLAY=:99

# start supervisord which manages Xvfb, x11vnc, and noVNC
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &

# tunggu xvfb siap
sleep 5

# start Brave browser (headless mode dimatikan agar bisa interaktif)
brave-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --start-fullscreen &

wait
