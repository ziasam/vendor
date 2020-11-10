# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

ADDITIONAL_BUILD_PROPERTIES += \
    ro.kangos.version=$(KANGOS_BASE_VERSION)-$(KANGOS_BUILD_TYPE)-$(BUILD_DATE)-$(BUILD_TIME) \
    ro.kangos.base.version=$(KANGOS_BASE_VERSION) \
    ro.mod.version=$(BUILD_ID)-$(BUILD_DATE)-$(KANGOS_BASE_VERSION) \
    ro.kangos.fingerprint=$(ROM_FINGERPRINT) \
    ro.kangos.buildtype=$(KANGOS_BUILD_TYPE) \
    ro.kangos.device=$(TARGET_PRODUCT)
