#!/system/vendor/bin/sh
app=`getprop sys.storage.bchmode`

if [ $app != "0" ]; then
	#echo 1 > sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
	#echo 1 > sys/devices/system/cpu/cpufreq/policy4/interactive/io_is_busy
	echo 960000 > sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
	echo 902400 > sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq
	echo 0 > sys/devices/soc/1da4000.ufshc/clkgate_enable
	echo 0 > sys/devices/soc/1da4000.ufshc/clkscale_enable
else
	#echo 0 > sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
	#echo 0 > sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
	echo 300000 > sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
	echo 300000 > sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq
	echo 1 > sys/devices/soc/1da4000.ufshc/clkgate_enable
	echo 1 > sys/devices/soc/1da4000.ufshc/clkscale_enable
fi
