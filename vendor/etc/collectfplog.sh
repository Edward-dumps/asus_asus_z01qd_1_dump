#!/vendor/bin/sh
FP_module=`getprop ro.hardware.fingerprint`
	rm -rf /sdcard/fingerprint-log
	cp -r /data/local/GF-MPTest/ /sdcard/fingerprint-log/