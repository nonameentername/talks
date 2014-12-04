#!/bin/bash

if which fswatch > /dev/null; then
    fswatch ./src make
else
    while inotifywait -re close_write ./src; do make; done
fi
