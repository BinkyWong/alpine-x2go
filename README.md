Based on https://github.com/yangxuan8282/docker-image

very very much alpha!!!

What you get:
* Minimal Alpine Linux base
* Xfce desktop
* Chomium, Firefox and Midori browser
* x2goserver running over SSH
* Intellij IDEA IDE 

To build:

`docker build -t alpine-desktop .`


To run:

docker run -d -p 6080:6080 -p 2222:22 -p 5900:5900 alpine-desktop

to browse to the desktop using your browser:

  http://your.ip.address:6080/vnc.html

or you can VNC to your.ip.address:5900

using the default password: alpinelinux


