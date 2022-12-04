#!/vendor/bin/sh

LOG_TAG="station_sd_switch"
type=`getprop sys.asus.station.sd_power`
sdname=`ls /mnt/media_rw/`
disk_count=`cat /sys/module/usb_storage/parameters/disk_count`

echo "$LOG_TAG:[USB] disk_count = $disk_count" > /dev/kmsg
if [ "$type" == "1" ]; then
	echo "$LOG_TAG:[USB_stor] station screen on" > /dev/kmsg
	echo 1 > /sys/class/ec_hid/dongle/device/sd_power
	echo 0 > /sys/devices/platform/soc/a600000.ssusb/SD_Transfer
elif [ "$type" == "2" ] && [ "$disk_count" = 0 ]; then
	echo "$LOG_TAG:[USB_stor] station screen off" > /dev/kmsg
	if [ `ls /mnt/media_rw/|wc -l` = 1 ] ; then
		result=`umount /mnt/media_rw/$sdname`
		if [ $? = 0 ] ; then
			echo "$LOG_TAG:[USB_stor] Umount /mnt/media_rw/$sdname success" > /dev/kmsg
			echo 0 > /sys/devices/platform/soc/a600000.ssusb/SD_Transfer
			if [ -z "$(ls -A /mnt/media_rw/$sdname)" ]; then
				rmdir /mnt/media_rw/$sdname
				echo 0 > /sys/class/ec_hid/dongle/device/sd_power
				echo "$LOG_TAG:[USB_stor] Remove sdcard mount point: $sdname" > /dev/kmsg
				echo "$LOG_TAG:[USB_stor] After umount success, Station SD controller need power off/power on to revcover" > /dev/kmsg
			else
				echo "$LOG_TAG:[USB_stor] This should not happened after umount success!!!" > /dev/kmsg
			fi
		else
			echo "$LOG_TAG:[USB_stor] Umount /mnt/media_rw/$sdname fail!!!" > /dev/kmsg
			echo 1 > /sys/devices/platform/soc/a600000.ssusb/SD_Transfer
		fi
	else
		echo "$LOG_TAG:[USB_stor] No unmount, folders under /mnt/media_rw:" > /dev/kmsg
		echo "$LOG_TAG:[USB_stor] $sdname" > /dev/kmsg
		echo 0 > /sys/class/ec_hid/dongle/device/sd_power
		echo 0 > /sys/devices/platform/soc/a600000.ssusb/SD_Transfer
	fi
fi
