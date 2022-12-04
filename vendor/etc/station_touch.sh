#!/vendor/bin/sh

type=`getprop sys.asus.dongletype`

if [ "$type" == "0" ]; then
	echo "No Dongle"
	rmmod /vendor/lib/modules/jedi_station_touch.ko
	exit 
elif [ "$type" == "1" ]; then
	echo "InBox"
	rmmod /vendor/lib/modules/jedi_station_touch.ko
	exit 
elif [ "$type" == "2" ]; then
	echo "Station not yet"
	insmod /vendor/lib/modules/jedi_station_touch.ko
	exit
elif [ "$type" == "3" ]; then
	echo "DT not yet"
	rmmod /vendor/lib/modules/jedi_station_touch.ko
	exit
elif [ "$type" == "4" ]; then
	echo "dongle type ERROR !!!!"
	rmmod /vendor/lib/modules/jedi_station_touch.ko
	exit
fi

