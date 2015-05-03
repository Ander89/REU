COMPONENT = TemAppC
CFLAGS += -I$(TINYOS_OS_DIR)/lib/printf
CFLAGS += -DNEW_PRINTF_SEMANTICS
PFLAGS += -I%T/sensorboards/mda100/cb
TINYOS_ROOT_DIR?=../..
include $(TINYOS_ROOT_DIR)/Makefile.include
$(call TOSMake_include_sensor,mda100)
