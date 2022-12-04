#!/vendor/bin/sh

#prop_type=`getprop sys.asus.dongletype`
LOG_TAG="EC_HID"

type_prop=`getprop sys.asus.dongletype`
type=`cat /sys/class/ec_hid/dongle/device/gDongleType`
event=`cat /sys/class/ec_hid/dongle/device/gDongleEvent`

boot_stage=`getprop vold.decrypt`
echo "[$LOG_TAG] vold.decrypt is $boot_stage " > /dev/kmsg
if [ "$boot_stage" == "trigger_restart_min_framework" ]; then
	echo "[$LOG_TAG] trigger_restart_min_framework" > /dev/kmsg
	setprop vendor.asus.security.startup 1

	echo "[$LOG_TAG] In security start-up, DO NOT send dongle type $type, event $event uevent." > /dev/kmsg

	exit
elif [ "$boot_stage" == "trigger_restart_framework" ]; then
	echo "[$LOG_TAG] trigger_restart_framework" > /dev/kmsg
	startup=`getprop vendor.asus.security.startup`

	if [ "$startup" == "1" ]; then
		echo "[$LOG_TAG] After security start-up, re-send dongle type $type, event $event uevent." > /dev/kmsg
		echo 0 > /sys/class/ec_hid/dongle/device/pogo_mutex
		echo $type > /sys/class/ec_hid/dongle/device/gDongleType
		setprop vendor.asus.security.startup 0
		exit
	fi

	if [ "$type_prop" == "$type" ]; then
		echo "[$LOG_TAG] Already run JediDongleSwitch, skip re-send dongle type!!! " > /dev/kmsg
		exit
	fi

	echo "[$LOG_TAG] re-send dongle type $type, event $event uevent, force unlock!!! " > /dev/kmsg
	echo 0 > /sys/class/ec_hid/dongle/device/pogo_mutex
	echo $type > /sys/class/ec_hid/dongle/device/gDongleType

	exit
fi

