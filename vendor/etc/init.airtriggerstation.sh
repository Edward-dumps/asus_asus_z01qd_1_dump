#!/vendor/bin/sh
gesture_type=`getprop persist.asus.airtriggerstationtouch`
echo "$gesture_type" > /sys/bus/i2c/devices/i2c-1/1-0038/airtrigger_station_touch

