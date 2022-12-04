#!/vendor/bin/sh

dongle_type=`getprop sys.asus.dongletype`
fan_type=`getprop persist.asus.userfan`
thermal_type=`getprop persist.asus.thermalfan`
micfansettings_type=`getprop persist.asus.micfansettings`
mic_type=`getprop sys.asus.fan.mic`


if [ "$dongle_type" == "2" ]; then
	if [ "$micfansettings_type" == "1" ] && [ "$mic_type" == "1" ]; then
		echo c 0 > /sys/class/ec_hid/dongle/device/set_gpio
		echo "[STATION_FAN][AUTO]enable_mic" > /dev/kmsg
	else
		if [ "$fan_type" == "auto" ]; then
			echo "thermal fan"
			if [ "$thermal_type" == "0" ]; then
				echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
				echo c > /sys/class/ec_hid/dongle/device/get_gpio
				echo 0 0 > /sys/class/ec_hid/dongle/device/freq
				echo ff 4b > /sys/class/ec_hid/dongle/device/duty
				echo 1 > /sys/class/ec_hid/dongle/device/pwm
				echo "[STATION_FAN][AUTO]thermal_type 0: default 1 (low)" > /dev/kmsg
			elif [ "$thermal_type" == "1" ]; then
				echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
				echo c > /sys/class/ec_hid/dongle/device/get_gpio
				echo 0 0 > /sys/class/ec_hid/dongle/device/freq
				echo ff 4b > /sys/class/ec_hid/dongle/device/duty
				echo 1 > /sys/class/ec_hid/dongle/device/pwm
				echo "[STATION_FAN][AUTO]fan_type 1 : low" > /dev/kmsg
			elif [ "$thermal_type" == "2" ]; then
				echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
				echo c > /sys/class/ec_hid/dongle/device/get_gpio
				echo 0 0 > /sys/class/ec_hid/dongle/device/freq
				echo ff 65 > /sys/class/ec_hid/dongle/device/duty
				echo 1 > /sys/class/ec_hid/dongle/device/pwm
				echo "[STATION_FAN][AUTO]fan_type 2 : medium" > /dev/kmsg 
			elif [ "$thermal_type" == "3" ]; then
				echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
				echo c > /sys/class/ec_hid/dongle/device/get_gpio
				echo 0 0 > /sys/class/ec_hid/dongle/device/freq
				echo ff 7f > /sys/class/ec_hid/dongle/device/duty
				echo 1 > /sys/class/ec_hid/dongle/device/pwm
				echo "[STATION_FAN][AUTO]fan_type 3 : high" > /dev/kmsg
			elif [ "$thermal_type" == "4" ]; then
				echo c 1 > /sys/class/ec_hid/dongle/device/set_gpio
				echo c > /sys/class/ec_hid/dongle/device/get_gpio
				echo 0 0 > /sys/class/ec_hid/dongle/device/freq
				echo ff 7f > /sys/class/ec_hid/dongle/device/duty
				echo 1 > /sys/class/ec_hid/dongle/device/pwm
				echo "[STATION_FAN][AUTO]thermal_type 4 will be set 3 (high)" > /dev/kmsg
			fi
		else
				echo "[STATION_FAN][AUTO]thermal fan will not  be set auto" > /dev/kmsg 
		fi
	fi
fi
