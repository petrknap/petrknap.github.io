---
layout: blog.post
title: "Screen / desktop #streaming via #ffmpeg"
category: software
keywords:
    - ffmpeg
    - X11
    - screen sharing
    - desktop sharing
    - screen streaming
    - desktop streaming
    - streaming
---

It is useful to stream your screen for someone else sometimes.
In these cases you can use many applications like Skype and Hangouts but you don't get control over it.
If you will create a **stream via ffmpeg** than server will **control quality and** client will control **scale**.


## Server

```bash
ffmpeg -f x11grab \
       -r 30 \
       -s $(xdpyinfo | grep 'dimensions:'|awk '{print $2}') \
       -i $DISPLAY \
       -qscale 0 \
       -an \
       -vcodec mpeg2video \
       -f mpegts udp://0.0.0.0:12345
```

Where
`-f x11grab` is **source**,
`-r 30` is **framerate**,
`-s $(xdpyinfo | grep 'dimensions:'|awk '{print $2}') -i $DISPLAY` determine captured **area**,
`-qscale 0` disables **scaling**,
`-an` disables **audio**,
`-vcodec mpeg2video` determines **video codec** H.262 and
`-f mpegts udp://0.0.0.0:12345` determine MPEG-TS output on all IPs on port 12345.
You need to append `?listen` if you wish to use TCP (f.e.: `tcp://0.0.0.0:12345?listen`).


## Client

```bash
ffplay -fflags nobuffer -flags low_delay -framedrop udp://127.0.0.1:12345
```

Where
`-fflags nobuffer -flags low_delay -framedrop` sets player for **minimal delay** and
`udp://127.0.0.1:12345` is IP of server and protocol and port from previous command.
It's stream, so **you can use VLC or other player** if you wish.


For more information visit [Capturing your Desktop / Screen Recording](https://trac.ffmpeg.org/wiki/Capture/Desktop).
