#!/bin/bash
# check if the log file was provided and if it exist or readable
if [ $# -eq 0 ] || [ ! -f "$1" ]; then
    echo "Error: missing or unreadable log file" >&2