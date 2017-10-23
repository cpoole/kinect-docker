### Build
`docker build -t local/libfreenect:latest .`

### Run
`nvidia-docker run --rm -it --privileged -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /usr/lib/x86_64-linux-gnu/libXv.so.1:/usr/lib/x86_64-linux-gnu/libXv.so.1 --env="DISPLAY" -v $(pwd):/workdir local/libfreenect:latest /bin/bash`
