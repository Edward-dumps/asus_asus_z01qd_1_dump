#!/vendor/bin/sh

speed=`getprop sys.asus.usb.speed`

LOG_TAG="usb_speed_switch"

if [ "$speed" == "2" ]; then
		echo "$LOG_TAG:[USB] set usb1&usb2 speed to high" > /dev/kmsg
		echo high > /sys/devices/platform/soc/a800000.ssusb/speed
		echo high > /sys/devices/platform/soc/a600000.ssusb/speed
elif [ "$speed" == "3" ]; then
		echo "$LOG_TAG:[USB] set usb1&usb2 speed to super" > /dev/kmsg
		echo super > /sys/devices/platform/soc/a800000.ssusb/speed
		echo super > /sys/devices/platform/soc/a600000.ssusb/speed
fi
