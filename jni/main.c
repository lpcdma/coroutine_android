#include "coroutine.h"
#include <stdio.h>

#include <android/log.h>
#define MODULE_NAME  "LOGXX"
#define LOGD(...) __android_log_print(ANDROID_LOG_ERROR, MODULE_NAME, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, MODULE_NAME, __VA_ARGS__)

struct args {
	int n;
};

static void
foo(struct schedule * S, void *ud) {
	struct args * arg = (struct args *)ud;
	int start = arg->n;
	int i;
	for (i=0;i<5;i++) {
		LOGD("coroutine %d : %d\n",coroutine_running(S) , start + i);
		coroutine_yield(S);
	}
}

static void
test(struct schedule *S) {
	struct args arg1 = { 0 };
	struct args arg2 = { 100 };

	int co1 = coroutine_new(S, foo, &arg1);
	int co2 = coroutine_new(S, foo, &arg2);
	LOGD("main start\n");
	while (coroutine_status(S,co1) && coroutine_status(S,co2)) {
		coroutine_resume(S,co1);
		coroutine_resume(S,co2);
	} 
	LOGD("main end\n");
}

int 
main() {
	// sleep(15);
	struct schedule * S = coroutine_open();
	test(S);
	coroutine_close(S);
	
	return 0;
}

