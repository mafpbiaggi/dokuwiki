#!/bin/bash

CONTAINER=$1
for i in {1..10}; do
    STATUS=$(docker inspect --format='{{ .State.Status }}' $CONTAINER)
    if [ "$STATUS" == "running" ]; then
        SERVICE=$(docker logs -n1 $CONTAINER 2>&1 | grep "apache2 -D FOREGROUND")
        if [[ ! -z $SERVICE ]]; then
            echo "[SUCCESS] Container '${CONTAINER}' is running."
            exit 0
        fi
    fi
    echo "Waiting for container... attempt $i"
    sleep 5
done
echo "[ERROR] Container '${CONTAINER}' status check failed."
echo "--------------------------------------------------------------------"
docker logs ${CONTAINER}
echo "--------------------------------------------------------------------"
exit 1
