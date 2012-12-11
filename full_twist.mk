include device/qcom/msm7627a/msm7627a.mk

PRODUCT_COPY_FILES := \
  device/geeksphone/twist/touch.idc:system/usr/idc/maxtouch-ts154.idc \
  device/geeksphone/twist/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
  device/geeksphone/twist/vold.fstab:system/etc/vold.fstab \
  device/geeksphone/twist/media_profiles.xml:system/etc/media_profiles.xml \
  device/geeksphone/twist/init/init.rc:root/init.rc \
  device/geeksphone/twist/init/init.qcom.usb.rc:root/init.qcom.usb.rc \
  device/geeksphone/twist/init/ueventd.rc:root/ueventd.rc

$(call inherit-product-if-exists, vendor/geeksphone/twist/vendor-blobs.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.moz.ril.simstate_extra_field=true \
  ro.moz.ril.emergency_by_default=true

# Discard inherited values and use our own instead.
PRODUCT_NAME := full_twist
PRODUCT_DEVICE := twist
PRODUCT_BRAND := qcom
PRODUCT_MANUFACTURER := GEEKSPHONE
PRODUCT_MODEL := GP-TWIST

PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
  persist.usb.serialno=$(PRODUCT_NAME)
