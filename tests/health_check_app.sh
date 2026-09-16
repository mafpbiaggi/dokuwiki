#!/bin/bash
set -e

if [[ ! $(curl -s http://localhost/doku.php?id=wiki:welcome | grep "Congratulations") ]]; then
    echo "[ERROR] HTTP health check failed on http://localhost/doku.php?id=wiki:welcome."
    exit 1
fi
echo "[SUCCESS] HTTP endpoint validated successfully."
