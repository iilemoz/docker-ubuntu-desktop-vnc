FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify \
    sudo \
    curl \
    wget \
    git \
    python3 \
    dbus-x11 \
    x11-xserver-utils \
    software-properties-common

RUN add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozilla-firefox && \
    apt update && apt install -y firefox

RUN mkdir -p /root/.vnc && \
    touch /root/.Xauthority

EXPOSE 7860

CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1280x720 --I-KNOW-THIS-IS-INSECURE :1 && \
    openssl req -new -subj '/C=US' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify --web=/usr/share/novnc/ --cert=self.pem 7860 localhost:5901"
