#!/vendor/bin/sh

device_PATH="/sys/bus/i2c/devices/i2c-1/1-0038/"
fw_PATH="/vendor/asusfw/station_touch/ASUS_JEDI_station_app.bin"

fw_verion_now=`cat $device_PATH/fts_fw_version`
fw_verion_new=`getprop sys.asusfw.station.tp_fwver`

IC_init=`cat $device_PATH/ftinitstatus`

echo "[Touch][station] firmware version now = $fw_verion_now ,new version = $fw_verion_new" > /dev/kmsg
if [ "$IC_init" = "0" ];then
	echo "[Touch][station] touch IC init =0 fail!" > /dev/kmsg
elif [ "$fw_verion_now" = "$fw_verion_new" ];then
	echo "[Touch][station] FW is new didn't upgrade!"
else
	echo $fw_PATH > $device_PATH/fts_upgrade_bin
	echo "[Touch][station] FW need upgrade!"
fi

# wait IC init
sleep 1

fw_verion_now=`cat $device_PATH/fts_fw_version`
if [ "$fw_verion_now" = "$fw_verion_new" ];then
	echo "[Touch][station] update successfully" > /dev/kmsg
	setprop sys.station.tp_fwupdate 0
else
	echo "[Touch][station] update fail!!" > /dev/kmsg
	setprop sys.station.tp_fwupdate 2
fi

start DongleFWCheck
