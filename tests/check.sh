#!/bin/bash
set -e

if [[ ! $(curl -s http://localhost/doku.php?id=wiki:welcome | grep "Congratulations") ]]; then
    echo "Test failed."
    exit 1
fi
echo "Test successful."
