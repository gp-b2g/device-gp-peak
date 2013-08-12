include device/qcom/msm7627a/msm7627a.mk

PRODUCT_COPY_FILES := \
  device/geeksphone/peak/touch.idc:system/usr/idc/maxtouch-ts154.idc \
  device/geeksphone/peak/touch.idc:system/usr/idc/himax-touchscreen.idc \
  device/geeksphone/peak/vold.fstab:system/etc/vold.fstab \
  device/geeksphone/peak/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
  device/geeksphone/peak/gps.conf:system/etc/gps.conf \
  device/geeksphone/peak/media_profiles.xml:system/etc/media_profiles.xml \
  device/geeksphone/peak/init/init.rc:root/init.rc \
  device/geeksphone/peak/init/init.target.rc:root/init.target.rc \
  device/geeksphone/peak/init/init.qcom.usb.rc:root/init.qcom.usb.rc \
  device/geeksphone/peak/init/ueventd.rc:root/ueventd.rc \
  device/geeksphone/peak/init/charger:root/charger \
  device/geeksphone/peak/audio.conf:system/etc/bluetooth/audio.conf \
  device/geeksphone/peak/init.qcom.post_boot.sh:system/etc/init.qcom.post_boot.sh \
  device/geeksphone/peak/prebuilt/3Gfix.sh:system/bin/3Gfix.sh \
  device/geeksphone/peak/prebuilt/fix_marketplace.sh:system/xbin/fix_marketplace.sh

ifneq (linux,$(HOST_OS))
PRODUCT_COPY_FILES += \
  device/geeksphone/peak/prebuilt/cfg80211.ko:system/lib/modules/ath6kl/cfg80211.ko \
  device/geeksphone/peak/prebuilt/ath6kl_sdio.ko:system/lib/modules/ath6kl/ath6kl_sdio.ko
endif

$(call inherit-product-if-exists, vendor/geeksphone/peak/vendor-blobs.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.moz.ril.simstate_extra_field=true \
  ro.moz.ril.emergency_by_default=true \
  ro.moz.ril.extra_int_2nd_call=true \
  sys.need.restart.rild=1 \
  ro.moz.omx.hw.max_width=960 \
  ro.moz.omx.hw.max_height=540 \
  ro.moz.fm.noAnalog=true

PRODUCT_PACKAGES += \
  librecovery \
  busybox

# Discard inherited values and use our own instead.
PRODUCT_NAME := full_peak
PRODUCT_DEVICE := peak
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := GEEKSPHONE
PRODUCT_MODEL := GP-Peak

PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
  persist.usb.serialno=$(PRODUCT_NAME)

# Gaia currently needs to specify the default scale value manually or pictures
# with correct resolution will not be applied.
GAIA_DEV_PIXELS_PER_PX := 1.5
