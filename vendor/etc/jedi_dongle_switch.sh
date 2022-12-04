#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`
event=`getprop sys.asus.dongleevent`
tmp1=`cat /sys/class/ec_hid/dongle/device/gDongleEvent`
inbox_1st_gen="/sys/class/leds/aura_sync_inbox"

if [ "$event" != "$tmp1" ]; then
	event=$tmp1
	echo "[EC_HID] reset event to $tmp1"
	setprop sys.asus.dongleevent $event
fi
echo "[EC_HID] JediDongleSwitch, type $type, event $event" > /dev/kmsg

declare -i retry

function reset_accy_fw_ver(){
	setprop sys.inbox.aura_fwver 0
	setprop sys.station.ec_fwver 0
	setprop sys.station.aura_fwver 0
	setprop sys.station.tp_fwver 0
	setprop sys.station.dp_fwver 0
	setprop sys.dt.aura_fwver 0
	setprop sys.dt.power_fwver 0
	setprop sys.station.pd_fwver 0
	setprop sys.dt.pd_fwver 0
	setprop sys.asus.accy.fw_status 000000
	setprop sys.asus.accy.fw_status2 000000
	setprop sys.asus.dt.ac_power "none"
	setprop vendor.oem.asus.dtid 0
}

# Define rmmod function
function remove_mod(){

	if [ -n "$1" ]; then
		echo "[EC_HID] remove_mod $1" > /dev/kmsg
	else
		exit
	fi

	test=1
	while [ "$test" == 1 ]
	do
		rmmod $1
		ret=`lsmod | grep $1`
		if [ "$ret" == "" ]; then
			echo "[EC_HID] rmmod $1 success" > /dev/kmsg
			test=0
		else
			echo "[EC_HID] rmmod $1 fail" > /dev/kmsg
			test=1
			sleep 0.5
		fi
	done
}

function check_accy_fw_ver(){

	echo "[EC_HID] Get Dongle FW Ver, type $type" > /dev/kmsg

	if [ "$type" == "1" ]; then
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

		while [ "$st_pdfw" == "ffff" -a "$retry" -lt 2 ]
		do
			echo "[PD_HID] retry check ver. $retry" > /dev/kmsg
			retry=$(($retry+1))
			st_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`
		done

		if [ "$st_pdfw" == "ffff" ]; then
			st_pdfw=""
		fi

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
			setprop sys.station.pd_fwver "$st_pdfw"
		elif [ "$st_pdfw" == "" ]; then
			echo "[PD_HID] PD FW Ver Error" > /dev/kmsg
			pd_status=1
			setprop sys.station.pd_fwver "0"
		else
			pd_status=1
			setprop sys.station.pd_fwver "$st_pdfw"
		fi

		HWID=`cat /sys/class/ec_hid/dongle/device/HWID`
		if [ "$HWID" != "0x1" ]; then
			echo "[PD_HID] old HWID" > /dev/kmsg
			pd_status=0
		fi

		setprop sys.asus.accy.fw_status 0"$aura_status""$tp_status""$ec_status"00

		setprop sys.asus.accy.fw_status2 "$pd_status"00000

	elif [ "$type" == "3" ]; then
		dt_aura=`cat /sys/class/leds/aura_sync_inbox/fw_ver`
		setprop sys.dt.aura_fwver $dt_aura

		dt_power=`cat /sys/class/leds/DT_power/fw_ver`
		setprop sys.dt.power_fwver $dt_power

		dt_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`

		while [ "$dt_pdfw" == "ffff" -a "$retry" -lt 2 ]
		do
			echo "[PD_DT] retry check ver. $retry" > /dev/kmsg
			retry=$(($retry+1))
			dt_pdfw=`cat /sys/class/usbpd/usbpd0/pdfw`
		done

		if [ "$dt_pdfw" == "ffff" ]; then
			power_role=`cat /sys/class/usbpd/usbpd0/current_pr`
			if [ "$power_role" == "source" ]; then
				echo "[PD_DT] PD FW Error reflash FW." > /dev/kmsg
				dt_pdfw="0"
				setprop sys.asus.dt.ac_power 1
				setprop sys.asus.accy.fw_status2 000100
			else
				dt_pdfw=`getprop sys.asusfw.dt.pd_fwver`
			fi
		fi
		setprop sys.dt.pd_fwver "$dt_pdfw"

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
}

if [ "$type" == "0" ]; then
	exit

elif [ "$type" == "1" ]; then
	echo "[EC_HID][Switch] InBox" > /dev/kmsg
	insmod /vendor/lib/modules/nct7802.ko
	insmod /vendor/lib/modules/ene_8k41_inbox.ko
	sleep 1
	if [ -d "$inbox_1st_gen" ]; then
		echo "[EC_HID][Switch] driver is 1st inbox" > /dev/kmsg
	else
		echo "[EC_HID][Switch]the driver is not ok,maybe it is the 2nd inbox" > /dev/kmsg
		echo 14 > /sys/class/ec_hid/dongle/device/sync_state
		exit
	fi

	# Close Phone aura
	echo 0 > /sys/class/leds/aura_sync/mode
	echo 1 > /sys/class/leds/aura_sync/apply
	echo 0 > /sys/class/leds/aura_sync/VDD

	# do not add any action behind here
	setprop sys.asus.donglechmod 1
	#start DongleFWCheck
	check_accy_fw_ver;
	echo 1 > /sys/class/ec_hid/dongle/device/sync_state

elif [ "$type" == "2" ]; then
	echo "[EC_HID][Switch] Station, Event $event" > /dev/kmsg

	# Check Station Dongle Event
	if [ "$event" == "1" ]; then
		echo "[EC_HID][Switch] ITE 8910 Force upgrade" > /dev/kmsg

		# Give Dummy EC fw_ver
		setprop sys.station.ec_fwver 000

		setprop sys.asus.accy.fw_status 000100

		# do not add any action behind here
		echo 7 > /sys/class/ec_hid/dongle/device/sync_state
		exit

	elif [ "$event" == "2" ]; then
		echo "[EC_HID][Switch] Station Low Battery" > /dev/kmsg

		# force reset accy FW
		reset_accy_fw_ver;

		# close HID keyboard state
		echo 0 > /sys/class/ec_hid/dongle/device/keyboard_enable

		# do not add any action behind here
		echo 12 > /sys/class/ec_hid/dongle/device/sync_state
		exit

	elif [ "$event" == "3" ]; then
		echo "[EC_HID][Switch] Station Shutdown & Virtual remove" > /dev/kmsg

		# force reset accy FW
		reset_accy_fw_ver;

		# Remove all driver
		echo 0 > /sys/bus/i2c/devices/2-0022/lightup
		setprop sys.stn.regenfw 0
		remove_mod jedi_station_touch
		echo 0 > /proc/driver/tfa9894_fw_load
		remove_mod ene_8k41_pogo
		remove_mod station_key

		# close HID keyboard state
		echo 0 > /sys/class/ec_hid/dongle/device/keyboard_enable

		# do not add any action behind here
		setprop sys.asus.donglechmod 0
		echo 12 > /sys/class/ec_hid/dongle/device/sync_state

		exit

	elif [ "$event" == "10" ]; then
		echo "[EC_HID][Switch] Connect YODA station" > /dev/kmsg

		# do not add any action behind here
		echo 15 > /sys/class/ec_hid/dongle/device/sync_state
		exit
	fi

	#insmod /vendor/lib/modules/iris3_i2c.ko
	echo 1 > /proc/driver/tfa9894_fw_load
	insmod /vendor/lib/modules/jedi_station_touch.ko
	insmod /vendor/lib/modules/ene_8k41_pogo.ko
	insmod /vendor/lib/modules/ene_8k41_station.ko
	insmod /vendor/lib/modules/station_key.ko

	# Enable HID keyboard
	echo 1 > /sys/class/ec_hid/dongle/device/keyboard_enable

	# Close Phone aura
	echo 0 > /sys/class/leds/aura_sync/mode
	echo 1 > /sys/class/leds/aura_sync/apply
	echo 0 > /sys/class/leds/aura_sync/VDD

	# do not add any action behind here
	setprop sys.asus.donglechmod 2
	#start DongleFWCheck
	check_accy_fw_ver;
	echo 2 > /sys/class/ec_hid/dongle/device/sync_state
	echo 1 > /sys/bus/i2c/devices/2-0022/lightup
	setprop sys.stn.regenfw 1

elif [ "$type" == "3" ]; then
	echo "[EC_HID][Switch] DT" > /dev/kmsg
	insmod /vendor/lib/modules/ene_8k41_inbox.ko
	insmod /vendor/lib/modules/ene_8k41_power.ko
	insmod /vendor/lib/modules/nct7802.ko

	rmmod /vendor/lib/modules/jedi_station_touch.ko

	AC_type=`cat /sys/class/leds/DT_power/Check_AC`
	if [ "$AC_type" == "0" ]; then
		echo "[EC_HID][Switch] DT AC is not 30W!!" > /dev/kmsg
		setprop sys.asus.dt.ac_power 0
	else
		echo "[EC_HID][Switch] DT AC is 30W!!" > /dev/kmsg
		setprop sys.asus.dt.ac_power 1
	fi

	# Close Phone aura
	echo 0 > /sys/class/leds/aura_sync/mode
	echo 1 > /sys/class/leds/aura_sync/apply
	echo 0 > /sys/class/leds/aura_sync/VDD

	# do not add any action behind here
	setprop sys.asus.donglechmod 3
	#start DongleFWCheck
	check_accy_fw_ver;

	echo 3 > /sys/class/ec_hid/dongle/device/sync_state

elif [ "$type" == "4" ]; then
	echo "[EC_HID][Switch] Type Error!!" > /dev/kmsg

	reset_accy_fw_ver;
	# do not add any action behind here
	echo 4 > /sys/class/ec_hid/dongle/device/sync_state

else
	echo "[EC_HID][Switch] Error Type $type" > /dev/kmsg
	echo 0 > /sys/class/ec_hid/dongle/device/pogo_mutex
fi
