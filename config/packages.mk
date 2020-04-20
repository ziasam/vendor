# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# KangOS Packages
PRODUCT_PACKAGES += \
    CustomDoze \
    StitchImage \
    ThemePicker \
    DU-Themes \
    PixelThemesStub2019 \
    WallpaperPickerGoogle

# Local Updater
ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_PACKAGES += \
    LocalUpdater
endif

PRODUCT_PACKAGES += \
     KangOSOverlayStub

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

-include vendor/kangos/config/overlay.mk
