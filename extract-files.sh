#!/bin/bash

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE=twist
COMMON=common
MANUFACTURER=GEEKSPHONE

if [[ -z "${ANDROIDFS_DIR}" && -d ../../../backup-${DEVICE}/system ]]; then
    ANDROIDFS_DIR=../../../backup-${DEVICE}
fi

if [[ -z "${ANDROIDFS_DIR}" ]]; then
    echo Pulling files from device
    DEVICE_BUILD_ID=`adb shell cat /system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
else
    echo Pulling files from ${ANDROIDFS_DIR}
    DEVICE_BUILD_ID=`cat ${ANDROIDFS_DIR}/system/build.prop | grep ro.build.display.id | sed -e 's/ro.build.display.id=//' | tr -d '\n\r'`
fi

echo Found firmware with build ID $DEVICE_BUILD_ID >&2

if [[ ! -d ../../../backup-${DEVICE}/system  && -z "${ANDROIDFS_DIR}" ]]; then
    echo Backing up system partition to backup-${DEVICE}
    mkdir -p ../../../backup-${DEVICE} &&
    adb pull /system ../../../backup-${DEVICE}/system
    cp ../../../backup-${DEVICE}/system/etc/wifi/WCN* ../../../backup-${DEVICE}/system/etc/firmware/wlan/volans
fi

BASE_PROPRIETARY_COMMON_DIR=vendor/$MANUFACTURER/$COMMON/proprietary
PROPRIETARY_DEVICE_DIR=../../../vendor/$MANUFACTURER/$DEVICE/proprietary
PROPRIETARY_COMMON_DIR=../../../$BASE_PROPRIETARY_COMMON_DIR

mkdir -p $PROPRIETARY_DEVICE_DIR

for NAME in adreno hw wifi etc
do
    mkdir -p $PROPRIETARY_COMMON_DIR/$NAME
done


COMMON_BLOBS_LIST=../../../vendor/$MANUFACTURER/$COMMON/vendor-blobs.mk

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > $COMMON_BLOBS_LIST
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
PRODUCT_COPY_FILES := device/sample/etc/apns-full-conf.xml:system/etc/apns-conf.xml

# All the blobs
PRODUCT_COPY_FILES += \\
EOF

# copy_file
# pull file from the device and adds the file to the list of blobs
#
# $1 = src name
# $2 = dst name
# $3 = directory path on device
# $4 = directory name in $PROPRIETARY_COMMON_DIR
copy_file()
{
    echo Pulling \"$1\"
    if [[ -z "${ANDROIDFS_DIR}" ]]; then
        adb pull /$3/$1 $PROPRIETARY_COMMON_DIR/$4/$2
    else
           # Hint: Uncomment the next line to populate a fresh ANDROIDFS_DIR
           #       (TODO: Make this a command-line option or something.)
           # adb pull /$3/$1 ${ANDROIDFS_DIR}/$3/$1
        cp ${ANDROIDFS_DIR}/$3/$1 $PROPRIETARY_COMMON_DIR/$4/$2
    fi

    if [[ -f $PROPRIETARY_COMMON_DIR/$4/$2 ]]; then
        echo   $BASE_PROPRIETARY_COMMON_DIR/$4/$2:$3/$2 \\ >> $COMMON_BLOBS_LIST
    else
        echo Failed to pull $1. Giving up.
        exit -1
    fi
}

# copy_files
# pulls a list of files from the device and adds the files to the list of blobs
#
# $1 = list of files
# $2 = directory path on device
# $3 = directory name in $PROPRIETARY_COMMON_DIR
copy_files()
{
    for NAME in $1
    do
        copy_file "$NAME" "$NAME" "$2" "$3"
    done
}

# copy_local_files
# puts files in this directory on the list of blobs to install
#
# $1 = list of files
# $2 = directory path on device
# $3 = local directory path
copy_local_files()
{
    for NAME in $1
    do
        echo Adding \"$NAME\"
        echo device/$MANUFACTURER/$DEVICE/$3/$NAME:$2/$NAME \\ >> $COMMON_BLOBS_LIST
    done
}

COMMON_LIBS="
    libauth.so
    libbinder.so
    libcamera_client.so
    libcameraservice.so
    libchromatix_hi542_ar.so
    libchromatix_hi542_preview.so
    libchromatix_hi542_video.so
    libchromatix_imx074_default_video.so
    libchromatix_imx074_preview.so
    libchromatix_imx074_video_hd.so
    libchromatix_imx074_zsl.so
    libchromatix_imx091_default_video.so
    libchromatix_imx091_preview.so
    libchromatix_imx091_video_hd.so
    libchromatix_mt9v113_ar.so
    libchromatix_mt9v113_preview.so
    libchromatix_mt9v113_video.so
    libchromatix_ov2720_default_video.so
    libchromatix_ov2720_hfr.so
    libchromatix_ov2720_preview.so
    libchromatix_ov2720_zsl.so
    libchromatix_ov5647_default_video.so
    libchromatix_ov5647_preview.so
    libchromatix_ov5647_sunny_p5v02s_default_video.so
    libchromatix_ov5647_sunny_p5v02s_preview.so
    libchromatix_ov5647_sunny_p5v02s_video_hfr.so
    libchromatix_ov5647_truly_cm6868_default_video.so
    libchromatix_ov5647_truly_cm6868_preview.so
    libchromatix_ov5647_truly_cm6868_video_hfr.so
    libchromatix_ov5647_video_hfr.so
    libchromatix_ov8825_default_video.so
    libchromatix_ov8825_preview.so
    libchromatix_s5k3l1yx_default_video.so
    libchromatix_s5k3l1yx_hfr_60fps.so
    libchromatix_s5k3l1yx_hfr_90fps.so
    libchromatix_s5k3l1yx_hfr_120fps.so
    libchromatix_s5k3l1yx_preview.so
    libchromatix_s5k3l1yx_video_hd.so
    libchromatix_s5k3l1yx_zsl.so
    libcm.so
    libcommondefs.so
    libcutils.so
    libdiag.so
    libDivxDrm.so
    libdivxdrmdecrypt.so
    libdl.so
    libdsi_netctrl.so
    libdsm.so
    libdsutils.so
    libgenlock.so
    libgps.so
    libgps.utils.so
    libhardware_legacy.so
    libidl.so
    libimage-jpeg-enc-omx-comp.so
    libimage-omx-common.so
    libloc_adapter.so
    libloc_api-rpc-qc.so
    libloc_eng.so
    libloc_ext.so
    libminui.so
    libmmcamera_faceproc.so
    libmmcamera_frameproc.so
    libmmcamera_hdr_lib.so
    libmmcamera_image_stab.so
    libmmcamera_interface2.so
    libmmcamera_statsproc31.so
    libmmcamera_wavelet_lib.so
    libmmipl.so
    libmmjpeg.so
    libmmstillomx.so
    libnetmgr.so
    libnl_2.so
    libnv.so
    liboemcamera.so
    liboem_rapi.so
    liboncrpc.so
    liboverlay.so
    libpbmlib.so
    libpower.so
    libpowermanager.so
    libqcci_legacy.so
    libqdi.so
    libqdp.so
    libqmi.so
    libqmi_client_qmux.so
    libqmi_csvt_srvc.so
    libqmiservices.so
    libqueue.so
    libreference-ril.so
    libril.so
    libril-qc-1.so
    libril-qc-qmi-1.so
    libril-qcril-hook-oem.so
    librpc.so
    libutils.so
    libwms.so
    libwmsts.so
    libwpa_client.so
	"

copy_files "$COMMON_LIBS" "system/lib" ""

COMMON_BINS="
    abtfilt
    akmd8963
    amploader
    ATFWD-daemon
    bridgemgrd
    ds_fmc_appd
    fmconfig
    fm_qsoc_patches
    hci_qcomm_init
    hostapd
    hostapd_cli
    mm-pp-daemon
    netcfg
    netd
    netmgrd
    port-bridge
    pppd
    qmiproxy
    qmuxd
    reboot
    rild
    vold
    wiperiface
    wiperiface_v01
    wpa_supplicant
	"

copy_files "$COMMON_BINS" "system/bin" ""

COMMON_HW="
    camera.msm7627a.so
    gps.default.so
    sensors.msm7627a.so
    sensors.msm7627a_sku7.so
    sensors.msm7627a_skua.so
	"

copy_files "$COMMON_HW" "system/lib/hw" "hw"

COMMON_WIFI="
    ansi_cprng.ko
    cfg80211.ko
    dal_remotetest.ko
    evbug.ko
    gspca_main.ko
    lcd.ko
    librasdioif.ko
    mmc_test.ko
    mtd_erasepart.ko
    mtd_nandecctest.ko
    mtd_oobtest.ko
    mtd_pagetest.ko
    mtd_readtest.ko
    mtd_speedtest.ko
    mtd_stresstest.ko
    mtd_subpagetest.ko
    mtd_torturetest.ko
    scsi_wait_scan.ko
    sleep_monitor.ko
    sm_event_driver.ko
    sm_event_log.ko
    wlan.ko
    zram.ko
	"

copy_files "$COMMON_WIFI" "system/lib/modules" "wifi"

ATH_WIFI="
    ath6kl_sdio.ko
    cfg80211.ko
"
copy_files "$COMMON_WIFI" "system/lib/modules/ath6kl" "wifi"

COMMON_WLAN_ATH="
    athtcmd_ram.bin
    athwlan.bin
    bdata.bin
    fw-3.bin
    nullTestFlow.bin
    softmac
    utf.bin
	"	
copy_files "$COMMON_WLAN_ATH" "system/etc/firmware/ath6k/AR6003/hw2.1.1" "wifi"

COMMON_ETC="
    gps.conf
    init.qcom.bt.sh
    init.qcom.coex.sh
    init.qcom.dsds_persist.sh
    init.qcom.set_dpi.sh
    init.qcom.usbcdrom.sh
    init.qcom.wifi.sh
    qlog-conf.xml
    vold.emmc.fstab
    vold.fat.fstab
    vold.origin.fstab
    wiperconfig.xml
    "
copy_files "$COMMON_ETC" "system/etc" "etc"

LIB_ADRENO="
    libC2D2.so
    libgsl.so
    libOpenVG.so
    libsc-a2xx.so
    "
copy_files "$LIB_ADRENO" "system/lib" "adreno"

LIB_EGL_ADRENO="
    egl.cfg
    eglsubAndroid.so
    libEGL_adreno200.so
    libGLES_android.so
    libGLESv1_CM_adreno200.so
    libGLESv2_adreno200.so
    libq3dtools_adreno200.so
    "
copy_files "$LIB_EGL_ADRENO" "system/lib/egl" "adreno"

LIB_FW_ADRENO="
    yamato_pm4.fw
    yamato_pfp.fw
    "
copy_files "$LIB_FW_ADRENO" "system/etc/firmware" "adreno"



