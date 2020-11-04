# Copyright (C) 2019 KangOS
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

KANGOS_CODENAME := R
KANGOS_REVISION := 4
KANGOS_SUBREVISION := 0

KANGOS_VERSION := $(KANGOS_REVISION).$(KANGOS_SUBREVISION)
KANGOS_BUILD_DATE := $(shell date -u +%Y%m%d-%H%M)

ifndef KANGOS_BUILDTYPE
    KANGOS_BUILDTYPE := UNOFFICIAL
endif

TARGET_PRODUCT_SHORT := $(TARGET_PRODUCT)
TARGET_PRODUCT_SHORT := $(subst kangos_,,$(TARGET_PRODUCT_SHORT))

ifeq ($(USE_GAPPS), true)
KANGOS_BUILD_ID := $(KANGOS_VERSION)-$(KANGOS_CODENAME)-Gapps-$(KANGOS_BUILDTYPE)-$(TARGET_PRODUCT_SHORT)-$(KANGOS_BUILD_DATE)
else
KANGOS_BUILD_ID := $(KANGOS_VERSION)-$(KANGOS_CODENAME)-$(KANGOS_BUILDTYPE)-$(TARGET_PRODUCT_SHORT)-$(KANGOS_BUILD_DATE)
endif

KANGOS_BUILD_FINGERPRINT := KangOS/$(KANGOS_VERSION)/$(TARGET_PRODUCT_SHORT)/$(KANGOS_BUILD_DATE)

# Apply it to build.prop
PRODUCT_PRODUCT_PROPERTIES += \
    ro.kangos.fingerprint=$(KANGOS_BUILD_FINGERPRINT) \
    ro.kangos.version=$(KANGOS_VERSION) \
    ro.kangos.build_id=KangOS-$(KANGOS_BUILD_ID) \
    ro.kangos.build.type=$(KANGOS_BUILDTYPE) 

ifeq ($(KANGOS_BUILDTYPE),OFFICIAL)
    PRODUCT_PRODUCT_PROPERTIES += ro.ota.kangos.build_id=$(KANGOS_BUILD_ID)
endif
