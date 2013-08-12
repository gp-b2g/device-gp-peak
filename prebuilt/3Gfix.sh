#!/system/bin/sh
#We need to get some data working so the connection dont get clossed. Only some
while true
do
	busybox ping 8.8.8.8 -c2 > /dev/null
	sleep 900
done;
