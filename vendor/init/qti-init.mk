# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/init

# Add legacy services and permissions for pre-5.10 targets
ifneq (,$(filter 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/init/init.qcom.early_boot.legacy.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.early_boot.sh \
    $(QCOM_COMMON_PATH)/vendor/init/init.qcom.post_boot.legacy.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.post_boot.sh

PRODUCT_PACKAGES += \
    init.qcom.legacy.rc
else
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/init/init.qcom.early_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.early_boot.sh \
    $(QCOM_COMMON_PATH)/vendor/init/init.qcom.post_boot.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qcom.post_boot.sh
endif

# Init
PRODUCT_PACKAGES += \
    init.aospa.perf.common.rc \
    init.aospa.perf.common.sh \
    init.qcom.aospa.rc \
    init.class_main.sh \
    init.crda.sh \
    init.mdm.sh \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.efs.sync.sh \
    init.qcom.rc \
    init.qcom.sdio.sh \
    init.qcom.sh \
    init.recovery.qcom.rc \
    init.veth_ipa_config.sh \
    qca6234-service.sh \
    ueventd.qcom.rc

ifneq (,$(filter userdebug, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += \
    ueventd.qcom.userdebug.rc
endif


# Charger
ifeq ($(TARGET_USE_HIDL_QTI_HEALTH),true)
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/init/init.charger_service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.charger_service.rc
endif

# Kernel
ifeq (,$(filter 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(QCOM_COMMON_PATH)/vendor/init/$(TARGET_BOARD_PLATFORM),$(TARGET_COPY_OUT_VENDOR))

PRODUCT_PACKAGES += \
    init.qti.kernel.rc \
    init.qti.kernel.sh \
    init.qti.write.sh

# If modules are present, load them.  If not, skip.
ifneq ($(KERNEL_MODULES_OUT),)
PRODUCT_PACKAGES += \
    system_dlkm_modprobe.sh \
    vendor_modprobe.sh
else
PRODUCT_VENDOR_PROPERTIES += \
    vendor.all.modules.ready=1
endif

else # Skip bin for < 5.4
$(warning Building for kernel $(TARGET_KERNEL_VERSION). Only copying device/qcom/common/vendor/init/$(TARGET_BOARD_PLATFORM)/etc folder.)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/qcom/common/vendor/init/$(TARGET_BOARD_PLATFORM)/etc,$(TARGET_COPY_OUT_VENDOR)/etc)

endif
