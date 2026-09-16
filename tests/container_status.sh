#!/bin/bash
CONTAINER=$1
STATUS=$(docker inspect --format='{{ .State.Status }}' $CONTAINER)

if [ "$STATUS" != "running" ]; then
    echo "[ERROR] Container '${CONTAINER}' state is '${STATUS}' (expected: running)."
    echo "--------------------------------------------------------------------"
    docker logs ${CONTAINER}
    echo "--------------------------------------------------------------------"
    exit 1
fi
echo "[SUCCESS] Container '${CONTAINER}' is healthy and running."
