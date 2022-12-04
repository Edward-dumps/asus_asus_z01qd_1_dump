#!/vendor/bin/sh
game_mode_type=`getprop sys.asus.gamingtype`
rotation_type=`getprop sys.screen.rotation`
game_exit=1

if [ "$game_mode_type" = "1" ];then
	if [ "$rotation_type" = "90" ];then
		echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG270_game_mode
		echo 1 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG90_game_mode
		echo "[Touch]in gaming mode and rotation = 90" >> /dev/kmsg
		game_exit=0
	elif [ "$rotation_type" = "270" ];then
		echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG90_game_mode
		echo 1 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG270_game_mode
		echo "[Touch]in gaming mode and rotation = 270" >> /dev/kmsg
		game_exit=0
	else
		echo "[Touch]in gaming mode but not rotation " >> /dev/kmsg		
				
elfi [ "$rotation_type" = "90" ];then # rotation set before game mode, sleep 300ms and retry
        sleep 0.3
        game_mode_type=`getprop sys.asus.gamingtype`
        if [ "$game_mode_type" = "1" ];then
       		echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG270_game_mode
		echo 1 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG90_game_mode
		echo "[Touch]in gaming mode and rotation = 90" >> /dev/kmsg
		game_exit=0
	fi
elfi [ "$rotation_type" = "270" ];then # rotation set before game mode, sleep 300ms and retry
        sleep 0.3
        game_mode_type=`getprop sys.asus.gamingtype`
        if [ "$game_mode_type" = "1" ];then
		echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG90_game_mode
		echo 1 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG270_game_mode
		echo "[Touch]in gaming mode and rotation = 270" >> /dev/kmsg
		game_exit=0
	fi
fi

	
if [ "$game_exit" = "1" ];then # rotation set before game mode, sleep 300ms and retry       
	echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG90_game_mode
	echo 0 > /sys/bus/i2c/devices/i2c-4/4-0038/checkG270_game_mode
	echo "[Touch]not in gaming mode" >> /dev/kmsg
fi



