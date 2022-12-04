#!/system/bin/sh

echo "boot complete relabel" > /proc/asusevtlog
restorecon -FR /data 2>/proc/asusevtlog >/proc/asusevtlog








