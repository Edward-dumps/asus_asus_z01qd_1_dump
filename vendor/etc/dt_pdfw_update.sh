#!/vendor/bin/sh

type=`getprop sys.dt.pd_fwupdate`
updateon=`getprop sys.dt.updatepdon`
asusfw=`getprop sys.asusfw.dt.pd_fwver`

if [ "$type" == "0" ]; then
	echo "[PD_DT] No need update PD FW" > /dev/kmsg
	exit
elif [ "$type" == "1" ]; then
	FW_PATH="/vendor/asusfw/DT_pd_fw/DT_DOCK_PD.bin"
fi

if [ "$updateon" != "1" ]; then
	echo "[PD_DT] PD update trun off" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  0
	exit
fi

echo 1 > /sys/class/leds/DT_power/pd_switch
echo 1 > /sys/class/leds/DT_power/pause
echo 1 > /sys/fs/selinux/ec

retry=0
while [ "$(lsusb | grep "05e3:0f01")" == "" -a "$retry" -lt 10 ]
do
	retry=$(($retry+1))

	if [ "$retry" -eq 10 ]; then
		echo "[PD_DT] can't find pdbillboard device" > /dev/kmsg
		setprop sys.dt.pd_fwupdate 2
		exit
	fi

	sleep 1
done

echo "[PD_DT] Start PD FW update : $FW_PATH" > /dev/kmsg

/vendor/bin/DTUSBPDFwUpdater -f /vendor/asusfw/DT_pd_fw/DT_DOCK_PD.bin 1

result=$?
if [ "$result" == "0" ]; then
	echo "[PD_DT] PD FW update OK" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  0
	setprop sys.dt.pd_fwver "$asusfw"

else
	echo "[PD_DT] PD FW update Fail $result" > /dev/kmsg
	setprop sys.dt.pd_fwupdate  2
fi

echo 0 > /sys/fs/selinux/ec
echo 0 > /sys/class/leds/DT_power/pause

echo "[PD_DT] Finish PD FW update" > /dev/kmsg
