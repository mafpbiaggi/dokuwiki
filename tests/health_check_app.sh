#!/bin/bash
set -euo pipefail

URL="http://localhost/doku.php?id=wiki:welcome"
for i in {1..20}; do
    if [[ $(curl -fs --max-time 5 "$URL" | grep "your wiki is now up and running") ]]; then
        echo "[SUCCESS] HTTP endpoint validated successfully."
        exit 0
    fi
    echo "Waiting for application... attempt $i"
    sleep 3
done
echo "[ERROR] HTTP health check failed on $URL."
exit 1
