#!/bin/bash
set -e
ldconfig
/usr/local/sbin/rwflowpack --sensor-configuration=/netflow/sensor.conf --site-config-file=/netflow/silk.conf --output-mode=local-storage --root-directory=/netflow --pidfile=/netflow/log/rwflowpack.pid --log-level=warning --log-destination=syslog

while true; do
    sleep 86400
done
