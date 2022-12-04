#!/vendor/bin/sh

emulate=`getprop vendor.aura.emulate`
on_ms=`getprop vendor.aura.emulate.on_ms`
off_ms=`getprop vendor.aura.emulate.off_ms`

if [ "$emulate" != "1" ]; then
	echo "[AURA_SYNC] Close emulated" > /dev/kmsg
	echo 0 > /sys/class/leds/aura_sync/emulate
	exit
fi

echo "[AURA_SYNC] Start emulated, $on_ms, $off_ms" > /dev/kmsg

echo $on_ms $off_ms > /sys/class/leds/aura_sync/blink_set

echo 1 > /sys/class/leds/aura_sync/emulate
