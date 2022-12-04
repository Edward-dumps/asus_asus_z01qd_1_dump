#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`

echo "[AURA_INBOX] Enable VDD" > /dev/kmsg
echo 1 > /sys/class/leds/aura_sync_inbox/VDD
sleep 0.5

FW_PATH="/vendor/asusfw/aura_sync/ENE-8K41-aura.bin"
fw_ver=`cat /sys/class/leds/aura_sync_inbox/fw_ver`
aura_fw=`getprop sys.asusfw.inbox.aura_fwver`

echo "[AURA_INBOX] aura_fw : ${aura_fw}" > /dev/kmsg
echo "[AURA_INBOX] fw_ver : ${fw_ver}" > /dev/kmsg

if [ "$type" == "3" ]; then
    echo 1 > /sys/class/leds/DT_power/pause
fi

if [ "${fw_ver}" != "${aura_fw}" ]; then
    echo "[AURA_INBOX] Strat ENE 8K41 FW update" > /dev/kmsg
    echo $FW_PATH > /sys/class/leds/aura_sync_inbox/fw_update
else
    echo "[AURA_INBOX] No need update" > /dev/kmsg
fi

fw_ver=`cat /sys/class/leds/aura_sync_inbox/fw_ver`
if [ "${fw_ver}" != "${aura_fw}" ]; then
	echo "[AURA_INBOX] ENE 8K41 FW update fail" > /dev/kmsg
	if [ "$type" == "1" ]; then
		setprop sys.inbox.aura_fwupdate 2
	elif [ "$type" == "3" ]; then
		echo 0 > /sys/class/leds/DT_power/pause
		setprop sys.dt.aura_fwupdate 2
	fi
else
	if [ "$type" == "1" ]; then
		setprop sys.inbox.aura_fwupdate 0
	elif [ "$type" == "3" ]; then
		echo 0 > /sys/class/leds/DT_power/pause
		setprop sys.dt.aura_fwupdate 0
	fi
fi

start DongleFWCheck
