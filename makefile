CWD = $(shell pwd)
MAKE = make -s

ASM=nasm
ASMFLAGS = -f elf32 -g
DIR_INCLUDE=-I $(DIR_SOURCE)/include
STRIP=strip -s
LD=ld
LDFLAGS=-T link.ld -n

DIR_SOURCE = $(CWD)/src/kernel
DIR_OBJECT = $(CWD)/obj/kernel
DIR_CONTENT = $(CWD)/bin/content/kernel

OBJECTS = $(patsubst $(DIR_SOURCE)/%.asm,$(DIR_OBJECT)/%_asm.o,$(shell find $(DIR_SOURCE) -iregex ".*\.asm"))

.PHONY: all kernel image clean clean-little do-the-real-cleaning do-the-real-cleaning-little

all: clean-little kernel image

image:
	@echo '-------- Creating floppy image'
	@bash bin/floppy.sh bin bin/floppy.img

kernel: $(DIR_OBJECT) $(DIR_CONTENT)
	@echo '-------- Building $@'
	@$(MAKE) $(DIR_CONTENT)/kernel.elf

$(DIR_OBJECT)/%_asm.o: $(DIR_SOURCE)/%.asm
	@mkdir -p $(dir $@)
	@echo 'ASM      $(patsubst $(DIR_SOURCE)/%,%,$<)'
	@$(ASM) $(ASMFLAGS) $(DIR_INCLUDE)/ -o $@ $<

$(DIR_OBJECT):
	@mkdir -p $@

$(DIR_CONTENT):
	@mkdir -p $@

$(DIR_CONTENT)/kernel.elf: $(OBJECTS)
	@echo 'LD       $(patsubst $(DIR_CONTENT)/%,%,$@)'
	@$(LD) $(LDFLAGS) -o $@ $(OBJECTS)
	#@$(STRIP) $(DIR_CONTENT)/kernel.elf

clean-little:
	@$(MAKE) do-the-real-cleaning-little

do-the-real-cleaning-little:
	@-rm -R $(DIR_CONTENT)/* $(DIR_BIN)/floppy.img 2> /dev/null

clean:
	@echo '-------- Cleaning directories'
	@$(MAKE) do-the-real-cleaning-little do-the-real-cleaning

do-the-real-cleaning:
	@echo 'RM       $(patsubst $(CWD)/%,%,$(DIR_OBJECT))/*'
	@-rm -R $(DIR_OBJECT)/* 2> /dev/null
