#!/bin/bash

if pgrep nginx >/dev/null 2>&1 && pgrep xray >/dev/null 2>&1; then
    echo "Nginx and Xray are running"
elif pgrep nginx >/dev/null 2>&1; then
    echo "Nginx is running but Xray is not"
elif pgrep xray >/dev/null 2>&1; then
    echo "Xray is running but Nginx is not"
else
    echo "Neither Nginx nor Xray are running"
fi
