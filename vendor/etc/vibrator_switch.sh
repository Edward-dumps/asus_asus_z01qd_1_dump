#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
LOG_TAG="vibrator_switch"
declare -i i 
if [ "$type" == "0" ]; then
	echo "$LOG_TAG:[VIB] No Dongle, switch to phone vibrator" > /dev/kmsg
	echo 0 > /sys/class/leds/vibrator/dongleType
	echo 1 > /sys/class/leds/vibrator/hwReset
elif [ "$type" == "1" ]; then
	echo "$LOG_TAG:[VIB] inbox, switch to phone vibrator" > /dev/kmsg
	echo 1 > /sys/class/leds/vibrator/dongleType
#	echo "$LOG_TAG:[VIB] inbox plug-in, vibrate ....." > /dev/kmsg
#	/system/bin/tinyplay /vendor/etc/firmware/sin_170Hz_0dBFS_0.5s.wav -D 0 -d 17 -i 0
elif [ "$type" == "2" ]; then
	echo "$LOG_TAG:[VIB] Station, switch to station vibrator" > /dev/kmsg
	echo 0 > /sys/class/leds/vibrator/vibEnable
#	echo 1 > /sys/class/leds/vibrator/hwReset
	echo 2 > /sys/class/leds/vibrator/dongleType
#	sleep 0.4
	echo 1 > /sys/class/leds/vibrator/hwReset
	echo 1 > /sys/class/leds/vibrator/vibEnable
	/system/bin/tinyplay /vendor/etc/firmware/station_dock.wav -D 0 -d 17 -i 0	-n 2 -p 256
#	/system/bin/tinyplay /vendor/etc/firmware/sin_170Hz_0dBFS_0.5s.wav -D 0 -d 17 -i 0
elif [ "$type" == "3" ]; then
	echo "$LOG_TAG:[VIB] DT, switch to phone vibrator" > /dev/kmsg
	echo 3 > /sys/class/leds/vibrator/dongleType
#	echo "$LOG_TAG:[VIB] DT plug-in, vibrate ....." > /dev/kmsg
#	/system/bin/tinyplay /vendor/etc/firmware/sin_170Hz_0dBFS_0.5s.wav -D 0 -d 17 -i 0
else
	echo "$LOG_TAG:[VIB] Dongle type ERROR, switch to phone vibrator" > /dev/kmsg
	echo 4 > /sys/class/leds/vibrator/dongleType
fi
