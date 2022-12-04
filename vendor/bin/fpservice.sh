#!/vendor/bin/sh
# start vendor.gx_fpd
# FP_module=`getprop ro.hardware.fingerprint`
# echo '$FP_module > /dev/kmsg'
FP_module=`getprop ro.hardware.fingerprint`
HW_module=`getprop ro.config.versatility`

if [ "$FP_module" == 'gx5206' ]; then
	start vendor.gx_fpd
elif [ "$FP_module" == 'gx5216' ]; then
	start vendor.gx_fpd
fi
echo "$FP_module" > /dev/kmsg
if [ "$HW_module" == 'CN' ]; then
	start TEEService
fi