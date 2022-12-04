#!/vendor/bin/sh

declare -i retry

type=`getprop sys.station.pd_fwupdate`
updateon=`getprop sys.station.updatepdon`

echo "[PD_HID] PD FW update" > /dev/kmsg

if [ "$type" == "0" ]; then
	echo "[PD_HID] No need update PD FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	FW_PATH="/vendor/asusfw/station/IT5213.bin"
fi

if [ "$updateon" != "1" ]; then
	echo "[PD_HID] PD update trun off" > /dev/kmsg
	setprop sys.station.pd_fwupdate 0
	exit
fi

HWID=`cat /sys/class/ec_hid/dongle/device/HWID`
if [ "$HWID" != "0x1" ]; then
	echo "[PD_HID] old HWID" > /dev/kmsg
	setprop sys.station.pd_fwupdate 0
	exit
fi

echo 32 0 > /sys/class/ec_hid/dongle/device/set_gpio
while [ "$(lsusb | grep -E "048d:5212|048d:52db")" == "" -a "$retry" -lt 3 ]
do
	retry=$(($retry+1))

	if [ "$retry" -eq 3 ]; then
		echo "[PD_HID] can't find pdhid device" > /dev/kmsg
		setprop sys.station.pd_fwupdate 2
		exit
	fi

	sleep 1
done

echo "[PD_HID] Start PD FW update : $FW_PATH" > /dev/kmsg

echo 1 > /sys/fs/selinux/ec

/vendor/bin/pd_update /vendor/asusfw/station/IT5213.bin

if [ "$?" != "1" ]; then
	echo "[PD_HID] PD FW update fail" > /dev/kmsg
	setprop sys.station.pd_fwupdate 2
else
	echo "[PD_HID] PD FW update OK" > /dev/kmsg
	setprop sys.station.pd_fwupdate 0
fi

echo 0 > /sys/fs/selinux/ec

setprop sys.asus.accy.fw_status2 000000
echo 32 1 > /sys/class/ec_hid/dongle/device/set_gpio
