SUBMODULE_DIR ?= $(CURDIR)

MODULES  += $(addprefix $(SUBMODULE_DIR)/,getcontext.o setcontext.o makecontext.o swapcontext.o) 

PTHREAD_GENERATE_MANGLE ?= -n "s/^.*@@@name@@@\([^@]*\)@@@value@@@[^0-9Xxa-fA-F-]*\([0-9Xxa-fA-F-][0-9Xxa-fA-F-]*\).*@@@end@@@.*\$$/\#define \1 \2/p"

$(SUBMODULE_DIR)/makecontext.o : $(SUBMODULE_DIR)/makecontext.c
	@echo "SUBMODULE_DIR='$(SUBMODULE_DIR)'" 
	$(CC) $(CFLAGS) -c $< -o $@

$(SUBMODULE_DIR)/getcontext.o: $(SUBMODULE_DIR)/getcontext.S $(SUBMODULE_DIR)/ucontext_i.h 
	$(CC) $(CFLAGS) -c $< -o $@

$(SUBMODULE_DIR)/setcontext.o: $(SUBMODULE_DIR)/setcontext.S $(SUBMODULE_DIR)/ucontext_i.h
	$(CC) $(CFLAGS) -c $< -o $@

$(SUBMODULE_DIR)/swapcontext.o: $(SUBMODULE_DIR)/swapcontext.S $(SUBMODULE_DIR)/ucontext_i.h
	$(CC) $(CFLAGS) -c $< -o $@

$(SUBMODULE_DIR)/ucontext_i.h: $(SUBMODULE_DIR)/ucontext_i.sym
	awk -f $(SUBMODULE_DIR)/scripts/gen-as-const.awk $< \
		| $(CC) $(CFLAGS) -x c - -S -o - \
			| sed $(PTHREAD_GENERATE_MANGLE) > $@
