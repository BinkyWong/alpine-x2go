# Based from the good work from https://github.com/yangxuan8282/docker-image

FROM alpine

COPY config /etc/skel/.config

RUN set -xe && \
     echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
     echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \ 
     echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

#RUN apk add --upgrade -no-cache apk-tools@testing
RUN apk update upgrade && \
    apk add --upgrade apk-tools@testing

RUN apk --update --no-cache add xvfb x11vnc xfce4 xfce4-terminal paper-icon-theme arc-theme@testing chromium python bash sudo htop procps curl openssh x2goserver git openjdk8 libressl@edge x11vnc@edgecommunity

RUN mkdir -p /usr/share/wallpapers \
  && curl https://img2.goodfon.com/original/2048x1820/3/b6/android-5-0-lollipop-material-5355.jpg -o /usr/share/wallpapers/android-5-0-lollipop-material-5355.jpg \
  && echo "CHROMIUM_FLAGS=\"--no-sandbox --no-first-run --disable-gpu\"" >> /etc/chromium/chromium.conf \
  && addgroup alpine \
  && adduser -G alpine -s /bin/bash -D alpine \
  && echo "alpine:alpine" | /usr/sbin/chpasswd \
  && echo "alpine ALL=NOPASSWD: ALL" >> /etc/sudoers \
  && apk del curl 

USER alpine

ENV USER=alpine \
    DISPLAY=:1 \
    LANG=en_GB.UTF-8 \
    LANGUAGE=en_GB.UTF-8 \
    HOME=/home/alpine \
    TERM=xterm \
    SHELL=/bin/bash \
    VNC_PASSWD=alpinelinux \
    VNC_PORT=5900 \
    VNC_RESOLUTION=1024x768 \
    VNC_COL_DEPTH=24  \
    SSH_PORT=22 \
    NOVNC_PORT=6080 \
    NOVNC_HOME=/home/alpine/noVNC 

RUN set -xe \
  && sudo apk update \
  && sudo apk add ca-certificates wget \
  && sudo update-ca-certificates \
  && mkdir -p $NOVNC_HOME/utils/websockify \
  && wget -qO- https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz | tar xz --strip 1 -C $NOVNC_HOME \
  && wget -qO- https://github.com/novnc/websockify/archive/v0.8.0.tar.gz | tar xzf - --strip 1 -C $NOVNC_HOME/utils/websockify \
  && chmod +x -v $NOVNC_HOME/utils/*.sh \
  && ln -s $NOVNC_HOME/vnc_auto.html $NOVNC_HOME/index.html 

RUN sudo bash -c 'echo "X11Forwarding yes" >> /etc/ssh/sshd_config' && \
    sudo bash -c 'echo "X11UseLocalhost no" >> /etc/ssh/sshd_config' && \
    sudo ssh-keygen -A 
    
WORKDIR $HOME

EXPOSE $VNC_PORT $NOVNC_PORT $SSH_PORT

COPY run_novnc /usr/bin/

CMD ["run_novnc"]
