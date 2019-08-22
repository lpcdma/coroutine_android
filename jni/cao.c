#include <ucontext.h>
#if defined(__ANDROID__)
extern int getcontext(ucontext_t * uctx);
extern int swapcontext(ucontext_t * ouctx, const ucontext_t * uctx);
extern void makecontext(ucontext_t * uctx, void (*func)(), int argc, ...);
#endif