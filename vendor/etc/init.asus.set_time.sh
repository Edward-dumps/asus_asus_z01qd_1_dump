#!/system/vendor/bin/sh

#ASUS_BSP +++ Show_Cai set default time
#sleep 5
#current_year=$(date +%Y)

#if [ "${current_year}" -gt 2000 ] && [ -f /data/set_time ]; then
#	setprop persist.asus.set_default_time 1
#fi

#set_default_time=`getprop persist.asus.set_default_time`

#if [ "${set_default_time}" != 1 ];then
#	date 0101000016.00
#	setprop persist.asus.set_default_time 1
#elif [ "${current_year}" -lt 1980 ]; then
#	date 0101000016.00
#fi
#ASUS_BSP --- Show_Cai set default time

#ASUS_BSP +++ Show_Cai set default timezone
first_boot=`getprop persist.asus.first_boot`

if [ "${first_boot}" != 1 ] || [ ! -f /data/property/persist.asus.first_boot ];then
	customer=`cat /vendor/factory/CUSTOMER`
	if [ "$customer" == "VF_IT" ];then
		setprop persist.sys.timezone "Europe/Brussels"
		echo "[RTC] CID:VF_IT Set persist.sys.timezone to Europe/Brussels" > /dev/kmsg
		#log -p v -t "[RTC]" "Set persist.sys.timezone to Europe/Brussels"
	fi

	if [ "$customer" == "WIND" ];then
		setprop persist.sys.timezone "Europe/Brussels"
		echo "[RTC] CID:WIND Set persist.sys.timezone to Europe/Brussels" > /dev/kmsg
		#log -p v -t "[RTC]" "Set persist.sys.timezone to Europe/Brussels"
	fi

	if [ "$customer" == "H3G" ];then
		setprop persist.sys.timezone "Europe/Brussels"
		echo "[RTC] CID:H3G Set persist.sys.timezone to Europe/Brussels" > /dev/kmsg
		#log -p v -t "[RTC]" "Set persist.sys.timezone to Europe/Brussels"
	fi

	if [ "$customer" == "TIM" ];then
		setprop persist.sys.timezone "Europe/Rome"
		echo "[RTC] CID:TIM Set persist.sys.timezone to Europe/Rome" > /dev/kmsg
		#log -p v -t "[RTC]" "Set persist.sys.timezone to Europe/Rome"
	fi

	setprop persist.asus.first_boot 1
fi
#ASUS_BSP --- Show_Cai set default timezone
