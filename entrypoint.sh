#!/bin/bash
Xvfb :1 -screen 0 800x600x16 &
/usr/bin/x11vnc -display :1.0 -passwd password -forever &
DISPLAY=:1.0
export DISPLAY
