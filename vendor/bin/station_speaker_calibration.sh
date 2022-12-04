#!/vendor/bin/sh
#!/bin/bash

tinyplay=0

/system/bin/tinymix 'TERT_MI2S_RX Audio Mixer MultiMedia1' 1

sleep 2

/system/bin/tinyplay /vendor/etc/silence.wav > /dev/null 2>&1 &

sleep 5
if [ "$1" == "0" ]; then
    climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt --resetmtpex > /dev/null 2>&1
    sleep 1
	cal_log=`climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt --calibrate=once` > /dev/null 2>&1
else
    echo "Invaild argument"
    return
fi

echo $cal_log > /data/data/station_cal_log.txt

spk1_cal=`climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt -A | grep "Current calibration impedance" | cut -d ' ' -f 4 | head -n 1`

echo $spk1_cal > /data/data/spk1_cali.txt

spk2_cal=`climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt -A | grep "Current calibration impedance" | cut -d ' ' -f 4 | tail -n 1`

echo $spk2_cal > /data/data/spk2_cali.txt

spk1_cal_int=`climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt -A | grep "Current calibration impedance" | cut -d ' ' -f 6 | head -n 1`

spk2_cal_int=`climax -d /dev/i2c-2 -l /vendor/asusfw/audio/tfa9894.cnt -A | grep "Current calibration impedance" | cut -d ' ' -f 6 | tail -n 1`

#echo $spk1_cal_int

#echo $spk2_cal_int

until [ "${tinyplay}" = "" ]
do
tinyplay=`ps | grep tinyplay`
sleep 1
done
    
if [ "$spk1_cal_int" -ge 68000 ] && [ "$spk1_cal_int" -le 99500 ] && [ "$spk2_cal_int" -ge 68000 ] && [ "$spk2_cal_int" -le 99500 ]; then
    echo "PASS"
else    
    echo "FAIL"
fi

/system/bin/tinymix 'TERT_MI2S_RX Audio Mixer MultiMedia1' 0

