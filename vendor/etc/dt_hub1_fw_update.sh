#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
update_flag=`getprop sys.dt.hub1_fwupdate`
fw_status2=`getprop sys.asus.accy.fw_status2`
LOG_TAG="dt_hub1_fw_update"
hub1_version=`getprop sys.dt.hub1_fwver`
lsusb_PATH="/storage/self/gl_usb_list"
FW_PATH="/vendor/asusfw/DT_hub_fw/DT_6961_HUB1.bin"
FW_VER=`getprop sys.asusfw.dt.hub1_fwver`

if [ "$update_flag" == "1" ]; then
	if [ "$type" == "3" ];then
		echo 1 > /sys/class/leds/DT_power/pd_switch
		echo 1 > /sys/class/leds/DT_power/pause
		echo "$LOG_TAG:[USB_ACCY] update fw $hub1_version to $FW_VER" > /dev/kmsg
		lsusb | grep 05e3:0610 > $lsusb_PATH
		/system/bin/DTHubFwUpdater isp -t single -n 0 -b $FW_PATH
		lsusb | grep 05e3:0610 > $lsusb_PATH
		hub1_version=`/system/bin/DTHubFwUpdater version |grep "\[0\]" | cut -d ":" -f 2`
		echo "$LOG_TAG:[USB_ACCY] DT hub1 version = $hub1_version" > /dev/kmsg
		setprop sys.dt.hub1_fwver $hub1_version
		if [ "$hub1_version" == "$FW_VER" ]; then
			echo "$LOG_TAG:[USB_ACCY] update success" > /dev/kmsg
			setprop sys.dt.hub1_fwupdate 0
			/system/bin/update_accy_status2.sh
		else
			echo "$LOG_TAG:[USB_ACCY] update fail" > /dev/kmsg
			setprop sys.dt.hub1_fwupdate 2
		fi
		rm $lsusb_PATH
		echo 0 > /sys/class/leds/DT_power/pause
		echo 0 > /sys/class/leds/DT_power/pd_switch
	else
		echo "$LOG_TAG:[USB_ACCY] not connect DT" > /dev/kmsg
		setprop sys.dt.hub1_fwupdate 2
	fi
fi
