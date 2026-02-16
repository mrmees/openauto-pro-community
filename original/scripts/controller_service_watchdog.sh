#!/bin/bash
cd $HOME

until /usr/local/bin/controller_service; do
    echo "Controller service terminated with exit code $?.  Restarting..." >&2
    sleep 5
done

