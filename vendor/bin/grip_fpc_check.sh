#!/vendor/bin/sh

export PATH=/vendor/bin

file_check_for_golden_k(){
    if [ -f $1 ]; then
		echo "$1 file is exist"
    else
		echo "create $1 file"
		cat /proc/lcd_unique_id > $1
		chmod 777 $1
    fi
}
file_check_for_golden_k /persist/grip_panel_id


Panel_ID_now="`cat /proc/lcd_unique_id`"
Panel_ID_orig="`cat /persist/grip_panel_id`"
echo "orig:$Panel_ID_orig now:$Panel_ID_now"
if [ "$Panel_ID_orig" == "$Panel_ID_now" ]; then
	setprop vendor.grip.use_golden 0
	echo 0 > /proc/driver/Grip_FPC_Check
	echo "panel id not change"
else
	setprop vendor.grip.use_golden 1
	echo 1 > /proc/driver/Grip_FPC_Check
	echo "get changed panel id"
fi

Bar0="`cat /proc/driver/Grip_FPC_Check`"
setprop vendor.grip.bar.result $Bar0
if [ "$Bar0" == "0xffff" ]; then
    setprop vendor.grip.bar.status 1
else
	setprop vendor.grip.bar.status 0
fi

B0_F="`cat /proc/driver/Grip_SQ_B0_factor`"
B1_F="`cat /proc/driver/Grip_SQ_B1_factor`"
B2_F="`cat /proc/driver/Grip_SQ_B2_factor`"
setprop vendor.grip.b0.30N.val $B0_F
setprop vendor.grip.b1.30N.val $B1_F
setprop vendor.grip.b2.30N.val $B2_F

#Bar1="`/data/data/GripSensor_SelfTest 0`"
#Bar1="`/data/data/GripSensor_SelfTest 1`"
#Bar2="`/data/data/GripSensor_SelfTest 2`"
#setprop debug.grip.bar0.status $Bar0
#setprop debug.grip.bar1.status $Bar1
#setprop debug.grip.bar2.status $Bar2
