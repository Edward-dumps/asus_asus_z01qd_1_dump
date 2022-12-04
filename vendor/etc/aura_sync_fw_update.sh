#!/vendor/bin/sh

type=`cat /sys/class/ec_hid/dongle/device/gDongleType`

if [ "$type" != "0" ]; then
	echo "[AURA_SYNC] In accy $type, skip update." > /dev/kmsg
	setprop sys.phone.aura_fwupdate 0
	exit
fi

FW_VER=`cat /vendor/asusfw/FW_version.txt | grep Aura_FW | cut -d ':' -f 2`
setprop sys.asusfw.phone.aura_fwver $FW_VER

echo "[AURA_SYNC] Enable VDD" > /dev/kmsg
echo 1 > /sys/class/leds/aura_sync/VDD
sleep 1

FW_PATH="/vendor/asusfw/aura_sync/ENE-8K41-aura.bin"
fw_ver=`cat /sys/class/leds/aura_sync/fw_ver`
aura_fw=`getprop sys.asusfw.phone.aura_fwver`

echo "[AURA_SYNC] aura_fw : ${aura_fw}" > /dev/kmsg
echo "[AURA_SYNC] fw_ver : ${fw_ver}" > /dev/kmsg

if [ "${fw_ver}" != "${aura_fw}" ]; then
    echo "[AURA_SYNC] Strat ENE 8K41 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/aura_sync/fw_update
else
    echo "[AURA_SYNC] No need update" > /dev/kmsg
fi

setprop sys.phone.aura_fwupdate 0
start DongleFWCheck
