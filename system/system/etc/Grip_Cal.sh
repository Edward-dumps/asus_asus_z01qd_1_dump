#!/system/bin/sh

export PATH=/vendor/bin
GRIP_CAL=`getprop persist.grip.calibration`
if [ "$GRIP_CAL" == "1" ]; then
	setprop persist.grip.calibration_done 0
	/vendor/bin/SNTMfgUtil -r
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar1
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "2" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar2
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "3" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -sb 30 pzt bar3
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "4" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -i
    setprop persist.grip.calibration_done 1
fi
if [ "$GRIP_CAL" == "5" ]; then
	setprop persist.grip.calibration_done 0
    /vendor/bin/SNTMfgUtil -c pzt
    setprop persist.grip.calibration_done 1
fi
