#!/bin/bash
echo 'Instance will automatically shutdown in 2 hours'
set -e
(( sleep 7200 && /sbin/shutdown -h now ) > /dev/null 2>&1 < /dev/null & )
