### android getcontext setcontext makecontext swapcontext support

### 兼容x86 armeabi-v7a armeabi arm64-v8a


## 重要说明 
1. 生成ucontext_i.h,参考cuttle MakeFile

```
awk -f src/ucontext/arm/scripts/gen-as-const.awk src/ucontext/aarch64/ucontext_i.sym | /home/ubuntu/android-ndk-r10e/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-gcc -std=gnu99 --sysroot="/home/ubuntu/android-ndk-r10e//platforms/android-21/arch-arm64" -march=armv8-a -Wall -Wextra -Wno-missing-field-initializers -O3 -g  -D__ANDROID__=1  -Isrc/android/android-ifaddrs -Isrc/android/android-spin-lock -Isrc/ucontext/aarch64 -x c - -S -o - | sed -n "s/^.*@@@name@@@\([^@]*\)@@@value@@@[^0-9Xxa-fA-F-]*\([0-9Xxa-fA-F-][0-9Xxa-fA-F-]*\).*@@@end@@@.*\$/#define \1 \2/p" > src/ucontext/aarch64/ucontext_i.h

awk -f src/ucontext/arm/scripts/gen-as-const.awk src/ucontext/x86/ucontext_i.sym | /home/ubuntu/android-ndk-r10e/toolchains/x86-4.9/prebuilt/linux-x86_64/bin/i686-linux-android-gcc -std=gnu99 --sysroot="/home/ubuntu/android-ndk-r10e//platforms/android-14/arch-x86" -march=i386 -Wall -Wextra -Wno-missing-field-initializers -O3 -g  -D__ANDROID__=1  -Isrc/android/android-ifaddrs -Isrc/android/android-spin-lock -Isrc/ucontext/x86 -x c - -S -o - | sed -n "s/^.*@@@name@@@\([^@]*\)@@@value@@@[^0-9Xxa-fA-F-]*\([0-9Xxa-fA-F-][0-9Xxa-fA-F-]*\).*@@@end@@@.*\$/#define \1 \2/p" > src/ucontext/x86/ucontext_i.h
```



参考项目
https://github.com/amyznikov/cuttle.git
https://github.com/google/breakpad