#!/vendor/bin/sh
FPver=`getprop goodix.fp.version`

final_ver="$FPver"

setprop fp.version.driver "$final_ver"