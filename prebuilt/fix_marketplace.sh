#!/system/bin/sh
#Delete old Marketplace icon
busybox sed -i '/"marketplace":/,/},/d' /data/local/webapps/webapps.json
rm -r /data/local/webapps/marketplace
chmod 666 /system/xbin/fix_marketplace.sh
