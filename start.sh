#!/bin/bash
inotifywait -e close_write,moved_to,create  . |
while read -r directory events filename; do
    if [ "$filename" = "Main.elm" ]; then
        elm make Main.elm --output elm.js
    fi
done
