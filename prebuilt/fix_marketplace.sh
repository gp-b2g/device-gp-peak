#!/system/bin/sh
#For PDI version is needed to delete indexedDB of homescreen to restore the new branding icons
rm -r /data/local/indexedDB/*homescreen*

#Delete old Marketplace icon
busybox sed -i '/"marketplace":/,/},/d' /data/local/webapps/webapps.json
rm -r /data/local/webapps/marketplace
chmod 666 /system/xbin/fix_marketplace.sh
