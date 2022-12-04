#!/vendor/bin/sh

cp -a /vendor/firmware/iris3.fw /persist/iris3.fw
irisConfig -outccfbin /persist/iris3.fw -calibration2 /vendor/firmware 2
irisConfig -configure 73 1 0
