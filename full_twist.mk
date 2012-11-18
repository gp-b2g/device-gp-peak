include device/qcom/msm7627a/msm7627a.mk

PRODUCT_COPY_FILES := \
  device/geeksphone/twist/app_process:system/bin/app_process \
  device/geeksphone/twist/touch.idc:system/usr/idc/sensor00fn11.idc \
  device/geeksphone/twist/touch.idc:system/usr/idc/himax-touchscreen.idc \
  device/geeksphone/twist/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
  device/geeksphone/twist/vold.fstab:system/etc/vold.fstab \

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
