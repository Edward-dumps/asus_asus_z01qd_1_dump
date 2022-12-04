#!/vendor/bin/sh

cp -a /vendor/firmware/iris3.fw /persist/iris3_gs.fw
irisConfig -outccfbin /persist/iris3_gs.fw -calibration2 /vendor/firmware 4
echo 1 > /sys/bus/i2c/devices/2-0022/update_fw
