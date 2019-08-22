LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE	:= cao

LOCAL_C_INCLUDES += ucontext
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
SUBMODULE_DIR = ucontext/arm
LOCAL_C_INCLUDES += ucontext/arm
LOCAL_SRC_FILES	:=    \
	ucontext/arm/makecontext.c \
	ucontext/arm/setcontext.S \
	ucontext/arm/swapcontext.S
endif

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
LOCAL_C_INCLUDES += ucontext/aarch64
LOCAL_SRC_FILES	:=    \
	ucontext/aarch64/makecontext.c \
	ucontext/aarch64/sysdep.c \
	ucontext/aarch64/swapcontext.S \
	ucontext/aarch64/setcontext.S
endif

ifeq ($(TARGET_ARCH_ABI),x86)
LOCAL_C_INCLUDES += ucontext/x86
LOCAL_SRC_FILES	:=    \
	ucontext/x86/makecontext.S \
	ucontext/x86/sysdep.S \
	ucontext/x86/swapcontext.S \
	ucontext/x86/setcontext.S
endif

LOCAL_SRC_FILES += ucontext/breakpad_getcontext.S 
LOCAL_SRC_FILES += cao.c

LOCAL_LDLIBS	+=	-L$(SYSROOT)/usr/lib -llog -lz -g
LOCAL_CPPFLAGS := -fexceptions -w -frtti
LOCAL_CFLAGS += -pie -fPIE -std=c99
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_ARM_MODE	:= arm
endif

ifeq ($(TARGET_ARCH_ABI),x86)
LOCAL_DISABLE_FATAL_LINKER_WARNINGS := true
LOCAL_LDFLAGS += -Wl,--no-warn-shared-textrel
endif
# include $(BUILD_STATIC_LIBRARY)
include $(BUILD_SHARED_LIBRARY)


# include $(CLEAR_VARS)
# LOCAL_MODULE	:= cao
# LOCAL_SRC_FILES := libcao.so
# include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
NDK_TOOLCHAIN_VERSION := clang
LOCAL_MODULE	:= shit
LOCAL_SRC_FILES	:=    \
	coroutine.c \
	main.c

LOCAL_LDLIBS	+=	-L$(SYSROOT)/usr/lib -llog -lz -g
LOCAL_CPPFLAGS := -fexceptions -frtti
LOCAL_CFLAGS += -pie -fPIE
LOCAL_LDFLAGS += -pie -fPIE
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_ARM_MODE	:= arm
endif
# LOCAL_STATIC_LIBRARIES := cao
LOCAL_SHARED_LIBRARIES := cao
include $(BUILD_EXECUTABLE)

dest_path := /data/local/tmp
all:
	adb push $(NDK_APP_DST_DIR)/shit $(dest_path)/
	adb shell "chmod 777 $(dest_path)/shit"
	adb push $(NDK_APP_DST_DIR)/libcao.so $(dest_path)/
	adb shell "chmod 777 $(dest_path)/libcao.so"
	adb shell "LD_LIBRARY_PATH=$(dest_path)/ $(dest_path)/shit"