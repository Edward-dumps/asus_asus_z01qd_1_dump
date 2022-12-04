#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`

echo "[EC_HID] Get Dongle FW Ver, type $type" > /dev/kmsg

if [ "$type" == "0" ]; then
	phone_aura=`cat /sys/class/leds/aura_sync/fw_ver`
	setprop sys.phone.aura_fwver $phone_aura

	setprop sys.inbox.aura_fwver 0
	setprop sys.station.ec_fwver 0
	setprop sys.station.aura_fwver 0
	setprop sys.station.tp_fwver 0
	setprop sys.station.dp_fwver 0
	setprop sys.dt.aura_fwver 0
	setprop sys.dt.power_fwver 0
	setprop sys.dt.pd_fwver 0
	setprop sys.station.pd_fwver 0

	setprop sys.asus.accy.fw_status 000000
	setprop sys.asus.accy.fw_status2 000000
elif [ "$type" == "1" ]; then
	inbox_aura=`cat /sys/class/leds/aura_sync_inbox/fw_ver`
	setprop sys.inbox.aura_fwver $inbox_aura

	# check FW need update or not
	aura_fw=`getprop sys.asusfw.inbox.aura_fwver`
	if [ "$inbox_aura" == "$aura_fw" ]; then
		setprop sys.asus.accy.fw_status 000000
	elif [ "$inbox_aura" == "i2c_error" ]; then
		echo "[EC_HID] InBox AURA_SYNC FW Ver Error" > /dev/kmsg
		setprop sys.asus.accy.fw_status 000000
	else
		setprop sys.asus.accy.fw_status 100000
	fi

elif [ "$type" == "2" ]; then
	station_aura=`cat /sys/class/leds/aura_sync_station/fw_ver`
	setprop sys.station.aura_fwver $station_aura

	station_ec=`cat /sys/class/ec_hid/dongle/device/fw_ver`
	setprop sys.station.ec_fwver $station_ec

	station_tp=`cat /sys/bus/i2c/devices/1-0038/fts_fw_version`
	if [ "$station_tp" == "" ]; then
		station_tp="version_wrong"
	fi
	setprop sys.station.tp_fwver $station_tp

	station_dp=`cat /sys/class/ec_hid/dongle/device/DP_FW`
	setprop sys.station.dp_fwver $station_dp

	st_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`
	setprop sys.station.pd_fwver $st_pdfw

	# check FW need update or not
	aura_fw=`getprop sys.asusfw.station.aura_fwver`
	if [ "$station_aura" == "$aura_fw" ]; then
		aura_status=0
	elif [ "$station_aura" == "i2c_error" ]; then
		echo "[EC_HID] Station AURA_SYNC FW Ver Error" > /dev/kmsg
		aura_status=0
	else
		aura_status=1
	fi

	ec_fw=`getprop sys.asusfw.station.ec_fwver`
	if [ "$station_ec" == "$ec_fw" ]; then
		ec_status=0
	elif [ "$station_ec" == "HID_not_connect" ]; then
		echo "[EC_HID] Station EC FW Ver Error" > /dev/kmsg
		ec_status=0
	elif [ "$station_ec" == "!D" ]; then
		echo "[EC_HID] cannot get Station EC FW Ver" > /dev/kmsg
		ec_status=0
	else
		ec_status=1
	fi

	tp_fw=`getprop sys.asusfw.station.tp_fwver`
	if [ "$station_tp" == "$tp_fw" ]; then
		tp_status=0
	elif [ "$station_tp" == "i2c_error" ] || [ "$station_tp" == "version_wrong" ]; then
		echo "[EC_HID] Station TP FW Ver Error" > /dev/kmsg
		tp_status=0
	else
		tp_status=1
	fi

	pd_fw=`getprop sys.asusfw.station.pd_fwver`
	if [ "$st_pdfw" == "$pd_fw" ]; then
		pd_status=0
	elif [ "$st_pdfw" == "ffff" ]; then
		echo "[PD_HID] PD FW Ver Error" > /dev/kmsg
		pd_status=0
	else
		pd_status=1
	fi

	setprop sys.asus.accy.fw_status 0"$aura_status""$tp_status""$ec_status"00

	setprop sys.asus.accy.fw_status2 "$pd_status"00000

elif [ "$type" == "3" ]; then
	dt_aura=`cat /sys/class/leds/aura_sync_inbox/fw_ver`
	setprop sys.dt.aura_fwver $dt_aura

	dt_power=`cat /sys/class/leds/DT_power/fw_ver`
	setprop sys.dt.power_fwver $dt_power

	dt_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`
	setprop sys.dt.pd_fwver $dt_pdfw

	# check FW need update or not
	aura_fw=`getprop sys.asusfw.dt.aura_fwver`
	if [ "$dt_aura" == "$aura_fw" ]; then
		aura_status=0
	elif [ "$dt_aura" == "i2c_error" ]; then
		echo "[EC_HID] DT AURA_SYNC FW Ver Error" > /dev/kmsg
		aura_status=0
	else
		aura_status=1
	fi

	power_fw=`getprop sys.asusfw.dt.power_fwver`
	if [ "$dt_power" == "$power_fw" ]; then
		power_status=0
	elif [ "$dt_power" == "i2c_error" ]; then
		echo "[EC_HID] DT Power EC FW Ver Error" > /dev/kmsg
		power_status=0
	else
		power_status=1
	fi

	setprop sys.asus.accy.fw_status 0000"$aura_status""$power_status"
fi

echo "[EC_HID] Get Dongle FW Ver done." > /dev/kmsg
