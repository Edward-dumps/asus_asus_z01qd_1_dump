#!/vendor/bin/sh

FW_PATH="/vendor/asusfw/station/IT8913.bin"

echo "[EC_HID] wait ec_update permissive 5s" > /dev/kmsg
echo 1 > /sys/fs/selinux/ec
echo 1 > /sys/class/ec_hid/dongle/device/lock

sleep 5

echo "[EC_HID] Start EC FW update : $FW_PATH" > /dev/kmsg
#/vendor/bin/ec_update /vendor/asusfw/station/IT8913.bin > /data/local/tmp/ec_update.log
/vendor/bin/ec_update /vendor/asusfw/station/IT8913.bin

echo 0 > /sys/class/ec_hid/dongle/device/lock
echo 0 > /sys/fs/selinux/ec

# wait HID reconnect
sleep 5

echo "[EC_HID] Finish EC FW update" > /dev/kmsg

ec_fw=`getprop sys.asusfw.station.ec_fwver`
fw_ver=`cat /sys/class/ec_hid/dongle/device/fw_ver`
if [ "${fw_ver}" != "${ec_fw}" ]; then
	echo "[EC_HID] EC FW update fail" > /dev/kmsg
	setprop sys.station.fwupdate  2

else
	setprop sys.station.fwupdate  0
fi

#echo "[EC_HID] Wait HID connect" > /dev/kmsg
#sleep 2

#start DongleFWCheck
setprop sys.asus.accy.fw_status 000000
