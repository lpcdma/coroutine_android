LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE	:= cao
LOCAL_C_INCLUDES += ucontext/arm
LOCAL_SRC_FILES	:=    \
	ucontext/arm/makecontext.c \
	ucontext/arm/getcontext.S \
	ucontext/arm/setcontext.S \
	ucontext/arm/swapcontext.S \
	cao.c

LOCAL_LDLIBS	+=	-L$(SYSROOT)/usr/lib -llog -lz
LOCAL_CPPFLAGS := -fexceptions -frtti
LOCAL_CFLAGS += -pie -fPIE -std=c99
LOCAL_ARM_MODE	:= arm
include $(BUILD_STATIC_LIBRARY)
#include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE	:= shit
LOCAL_C_INCLUDES += ucontext/arm
LOCAL_SRC_FILES	:=    \
	coroutine.c \
	main.c

LOCAL_LDLIBS	+=	-L$(SYSROOT)/usr/lib -llog -lz
LOCAL_CPPFLAGS := -fexceptions -frtti
LOCAL_CFLAGS += -pie -fPIE -std=c99
LOCAL_LDFLAGS += -pie -fPIE
LOCAL_ARM_MODE	:= arm
LOCAL_STATIC_LIBRARIES := cao
include $(BUILD_EXECUTABLE)

dest_path := /data/local/tmp
all:
	adb push $(NDK_APP_DST_DIR)/shit $(dest_path)/
	adb shell "chmod 777 $(dest_path)/shit"
	adb shell "$(dest_path)/shit"