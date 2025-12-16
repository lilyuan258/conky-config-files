#!/bin/bash
killall conky
sleep 1
conky -c ~/.config/conky/conky.conf --daemonize --quiet
conky -c ~/.config/conky/conky_left.conf --daemonize --quiet
