#!/vendor/bin/sh
gesture_type=`getprop persist.asus.airtriggertouch`
echo "$gesture_type" > /sys/bus/i2c/devices/i2c-4/4-0038/airtrigger_touch

