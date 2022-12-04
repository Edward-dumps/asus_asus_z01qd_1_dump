#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`

echo "[FAN][USER] dongle:$dongle_type, fan:$fan_type, mic fan:$micfansettings_type, mic type:$mic_type" > /dev/kmsg

if [ "$dongle_type" == "1" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
		cat /sys/class/hwmon/Inbox_Fan/device/PWM
		echo "[INBOX_FAN][USER]enable_mic" > /dev/kmsg
	else
		if [ "$fan_type" == "0" ]; then
			echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][USER]disable fan" > /dev/kmsg
		elif [ "$fan_type" == "1" ]; then
			echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][USER]fan_type 1 : low" > /dev/kmsg
		elif [ "$fan_type" == "2" ]; then
			echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][USER]fan_type 2 : medium" > /dev/kmsg
		elif [ "$fan_type" == "3" ]; then
			echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][USER]fan_type 3 : high" > /dev/kmsg
		elif [ "$fan_type" == "4" ]; then
			echo 4 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
			cat /sys/class/hwmon/Inbox_Fan/device/PWM
			echo "[INBOX_FAN][USER]fan_type 4 : turbo" > /dev/kmsg
		elif [ "$fan_type" == "auto" ]; then
			setprop persist.asus.tempfan 1
			echo "[INBOX_FAN][USER]thermal fan will be set auto" > /dev/kmsg
		fi
	fi
fi
