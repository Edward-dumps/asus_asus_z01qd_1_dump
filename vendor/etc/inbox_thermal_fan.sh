#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
thermal_type=`getprop persist.asus.thermalfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`

echo "[FAN][AUTO] dongle:$dongle_type, fan:$fan_type, thermal:$thermal_type, mic fan:$micfansettings_type, mic type:$mic_type" > /dev/kmsg

if [ "$dongle_type" == "1" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo 0 > /sys/class/hwmon/Inbox_Fan/device/inbox_user_type
		cat /sys/class/hwmon/Inbox_Fan/device/PWM
		echo "[INBOX_FAN][AUTO]enable_mic" > /dev/kmsg
	else
		if [ "$fan_type" == "auto" ]; then
			echo "thermal fan"
			if [ "$thermal_type" == "0" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 0: default 1 (low)" > /dev/kmsg
			elif [ "$thermal_type" == "1" ]; then
				echo 1 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 1: low" > /dev/kmsg
			elif [ "$thermal_type" == "2" ]; then
				echo 2 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 2: mediun" > /dev/kmsg
			elif [ "$thermal_type" == "3" ]; then
				echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 3: high" > /dev/kmsg
			elif [ "$thermal_type" == "4" ]; then
				echo 3 > /sys/class/hwmon/Inbox_Fan/device/inbox_thermal_type
				cat /sys/class/hwmon/Inbox_Fan/device/PWM
				echo "[INBOX_FAN][AUTO]thermal_type 4 will be set 3 (high)" > /dev/kmsg
			fi
		else
				echo "[INBOX_FAN][AUTO]thermal fan will not  be set auto" > /dev/kmsg
		fi
	fi
fi
