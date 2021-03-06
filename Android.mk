ifeq ($(TARGET_HW_KEYMASTER_V03),true)
LOCAL_PATH := $(call my-dir)

ifeq ($(call is-vendor-board-platform,QCOM),true)

keymaster-def := -fvisibility=hidden -Wall
ifeq ($(TARGET_BOARD_PLATFORM),$(filter $(TARGET_BOARD_PLATFORM),apq8084 msm8084 msm8974 msm8226 msm8610 msm8960))
keymaster-def += -D_ION_HEAP_MASK_COMPATIBILITY_WA
endif
ifeq ($(TARGET_KEYMASTER_WAIT_FOR_QSEE),true)
LOCAL_CFLAGS += -DWAIT_FOR_QSEE
endif

include $(CLEAR_VARS)

LOCAL_MODULE := keystore.$(TARGET_BOARD_PLATFORM)

LOCAL_MODULE_RELATIVE_PATH := hw

LOCAL_SRC_FILES := keymaster_qcom.cpp

LOCAL_C_INCLUDES := $(TARGET_OUT_HEADERS)/common/inc \
                    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
                    external/openssl/include

LOCAL_CFLAGS := $(keymaster-def)

LOCAL_SHARED_LIBRARIES := \
        libcrypto \
        liblog \
        libc \
        libdl \
        libcutils

LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk \
                                 $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

endif # TARGET_BOARD_PLATFORM
else
LOCAL_MODULE := keystore.qcom
$(info Removing keymaster v0.3 bins)
$(shell rm -rf $(TARGET_OUT_INTERMEDIATES)/SHARED_LIBRARIES/$(LOCAL_MODULE)_intermediates )
$(shell rm -rf $(TARGET_OUT)/lib/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT)/lib64/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT)/../symbols/system/lib/hw/$(LOCAL_MODULE).so )
$(shell rm -rf $(TARGET_OUT_INTERMEDIATES)/lib/$(LOCAL_MODULE).so )
$(shell rm -fr $(TARGET_OUT_INTERMEDIATES)/lib64/$(LOCAL_MODULE).so )

endif # end of TARGET_HW_KEYMASTER_V03
