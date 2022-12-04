#!/vendor/bin/sh

# This service is for umount xrom

gsi_flag=`getprop ro.product.name`

if test "$gsi_flag" = "aosp_arm64"; then
	umount /vendor/xrom
fi

if test "$gsi_flag" = "aosp_arm64_ab"; then
	umount /vendor/xrom
fi
