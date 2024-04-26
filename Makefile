NPROC=$(shell nproc)
SHELL:=/bin/bash

# clear the log file every boot
CLEAR_LOG_ON_BOOT = 0
# debug logging with xlog
DEBUG_XLOG = 1
# tweaks for the release build
#ALPHARELEASE = 0.10

LCDFONT_OFFSET=0x2260
LOADER_OFFSET=0x1500
LOADER_ADDR=0x80001500
LOADER_ADDR_MAX=0x80002180

MIPS=/opt/mips32-mti-elf/2019.09-03-2/bin/mips-mti-elf-

CC = $(MIPS)gcc
CXX = $(MIPS)g++
LD = $(MIPS)ld
OBJCOPY = $(MIPS)objcopy

CFLAGS := -EL -march=mips32 -mtune=mips32 -msoft-float
CFLAGS += -Os -G0 -mno-abicalls -fno-pic
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -I libs/libretro-common/include
# CFLAGS += -Wall
ifeq ($(CLEAR_LOG_ON_BOOT), 1)
CFLAGS += -DCLEAR_LOG_ON_BOOT=1
endif
ifeq ($(DEBUG_XLOG), 1)
CFLAGS += -DDEBUG_XLOG=1
endif

LDFLAGS := -EL -nostdlib -z max-page-size=32
LDFLAGS += --gc-sections
# needed for .text LMA = VMA
LDFLAGS += --build-id

CXX_LDFLAGS := -EL -march=mips32 -mtune=mips32 -msoft-float
CXX_LDFLAGS += -Wl,--gc-sections --static
CXX_LDFLAGS += -z max-page-size=32

CORE_OBJS=core_api.o lib.o debug.o video_sf2000.o
LOADER_OBJS=init.o main.o debug.o

# CORE=cores/cannonball
# CONSOLE=outrun

#CORE=cores/ecwolf/src/libretro
#CONSOLE=ecwolf

# CORE=cores/fake-08/platform/libretro
# CONSOLE=fake8

# CORE=cores/caprice32
# CONSOLE=cap32

# CORE=cores/prboom
# CONSOLE=prboom

# CORE=cores/mame2000
# CONSOLE=m2k

# CORE=cores/vice
# CONSOLE=vic20
# CONSOLE=c64

# CORE=cores/2048
# MAKEFILE=-f Makefile.libretro
# CONSOLE=2048

# CORE=cores/lowres-nx/platform/LibRetro
# CONSOLE=lownx

# CORE=cores/stella2014
# CONSOLE=a26

# CORE=cores/atari5200
# CONSOLE=a52

# CORE=cores/atari800
# CONSOLE=a800

# CORE=cores/beetle-pce-fast
# CONSOLE=pce

# CORE=cores/beetle-supergrafx
# CONSOLE=pcesgx

# CORE=cores/gambatte
# CORE=cores/tgbdual
# CONSOLE=gb

#CORE=cores/gpsp
#CONSOLE=gba

# CORE=cores/snes9x2005
# CONSOLE=snes

# Default target
ifneq ($(CORE),)
all: core_87000000 bisrv.asd install
else
all: bisrv.asd install
endif

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.s
	$(CC) $(CFLAGS) -o $@ -c $<

libretro_core:
	@$(call echo_i,"compiling $(CORE)")
	$(MAKE) -j$(NPROC) -C $(CORE) $(MAKEFILE) platform=sf2000

libretro_core.a: libretro_core
	cp $(CORE)/*.a libretro_core.a

libretro-common:
	@$(call echo_i,"compiling $@")
	$(MAKE) -j$(NPROC) -C libs/libretro-common

libretro-common.a: libretro-common
	cp -u libs/libretro-common/$@ $@

core.elf: libretro_core.a libretro-common.a $(CORE_OBJS)
	@$(call echo_i,"compiling $@")
	$(CXX) -Wl,-Map=$@.map $(CXX_LDFLAGS) -e __core_entry__ -Tcore.ld bisrv_08_03-core.ld -o $@ \
		-Wl,--start-group $(CORE_OBJS) libretro_core.a libretro-common.a -lc -Wl,--end-group

core_87000000: core.elf
	$(OBJCOPY) -O binary -R .MIPS.abiflags -R .note.gnu.build-id -R ".rel*" core.elf core_87000000

loader.elf: $(LOADER_OBJS)
	@$(call echo_i,"compiling $@")
	$(LD) -Map $@.map $(LDFLAGS) -e __start -Ttext=$(LOADER_ADDR) bisrv_08_03.ld $(LOADER_OBJS) -o loader.elf

loader.bin: loader.elf
	$(Q)$(OBJCOPY) -O binary -j .text -j .rodata -j .data loader.elf loader.bin

bisrv.asd: loader.bin lcd_font.bin crc
	@$(call echo_i,"patching $@")

# check that loader's .bss does not exceeds LOADER_ADDR_MAX
	@BSSEND=$(shell grep -w "_end =" loader.elf.map | awk '{print $$1}'); \
	if [ $$(($${BSSEND})) -gt $$(($(LOADER_ADDR_MAX))) ]; then \
		$(call echo_e,"error: loader is too big. \
		bss ending $${BSSEND} exceeds $(LOADER_ADDR_MAX) by \
		$$(( $${BSSEND} - $(LOADER_ADDR_MAX) )) bytes") ; \
		exit 1; \
	else \
		echo "bss ending $${BSSEND}. still $$(( $(LOADER_ADDR_MAX) - $${BSSEND} )) bytes left" ; \
	fi

# check that lcd_font.bin has the anticipated size
	@LCDFONT_SIZE=$(shell stat -c %s lcd_font.bin) ; \
	if [ $${LCDFONT_SIZE} -ne 672 ]; then \
		$(call echo_e,"error: lcd_font.bin size $${LCDFONT_SIZE}. should be 672") ; \
		exit 1; \
	fi

	$(Q)cp bisrv_08_03.asd bisrv.asd

	$(Q)dd if=loader.bin of=bisrv.asd bs=$$(($(LOADER_OFFSET))) seek=1 conv=notrunc 2>/dev/null

	dd if=lcd_font.bin of=bisrv.asd bs=$$(($(LCDFONT_OFFSET))) seek=1 conv=notrunc

	# note: this patch must match $(LOADER_ADDR)
	# jal run_gba -> jal 0x80001500
	printf "\x40\x05\x00\x0C" | dd of=bisrv.asd bs=1 seek=$$((0x30f0bc)) conv=notrunc

	# endless loop in sys_watchdog_reboot -> j 0x80001508
	printf "\x42\x05\x00\x08" | dd of=bisrv.asd bs=1 seek=$$((0x30d4)) conv=notrunc
	# endless loop in INT_General_Exception_Hdlr -> j 0x80001510
	printf "\x44\x05\x00\x08" | dd of=bisrv.asd bs=1 seek=$$((0x495a0)) conv=notrunc

	# patch the buffer size for handling the save state snapshot image
	# \x0c (768k) would be enough up to cores displaying at 640x480x2
	printf "\x0c" | dd of=bisrv.asd bs=1 seek=$$((0x34f8b8)) conv=notrunc

	$(Q)./crc bisrv.asd

lcd_font.bin: lcd_font.o
	$(OBJCOPY) -O binary -j ".rodata.lcd_font" $< $@

crc: crc.c
	gcc -o crc crc.c

install:
	@$(call echo_i,"install to sdcard")
	-$(call copy_if_updated,bisrv.asd,sdcard/bios/bisrv.asd)
	-$(call copy_if_updated,core_87000000,sdcard/cores/$(CONSOLE)/core_87000000)
	# -rm -f sdcard/log.txt
	@$(call echo_d,"bisrv.asd")
	@$(call echo_d,"$(CORE)")

ifneq ($(ALPHARELEASE),)
updatelogo:
	@$(call echo_i,"update boot logo")
	-$(call update_bisrv_logo,sdcard/bios/bisrv.asd)
	@$(call echo_d,"$(1) logo updated")
else
updatelogo:
	@$(call echo_e,"ALPHARELEASE not defined!")
endif

# Clean intermediate files and the final executable
clean:
	-rm -f $(CORE_OBJS)
	-rm -f $(LOADER_OBJS) lcd_font.o
	-rm -f loader.elf loader.bin core.elf core.elf.map core_87000000
	-rm -f bisrv.asd crc
	-rm -f libretro_core.a
	$(MAKE) -j$(NPROC) -C $(CORE) $(MAKEFILE) clean platform=sf2000

.PHONY: all clean

define echo_i
    echo -e "\033[1;33m$(1)\033[0m"
endef

define echo_e
    echo -e "\033[1;31m$(1)\033[0m"
endef

define echo_d
    echo -e "\033[1;37m$(1)\033[0m"
endef

define copy_if_updated
	diff -q $(1) $(2) || (rm -rf $$(dirname $(2)) && mkdir -p $$(dirname $(2)) && cp $(1) $(2) && echo "$(1) updated")
endef

define update_bisrv_logo
	printf "\xB8\x0B" | dd of=$(1) bs=1 seek=$$((0x3463d0)) conv=notrunc && \
	convert /home/adcockm/downloads/multicore_alpha_release/Multicore_Boot_Logo_-_Xmasprint_-_RGB565.png -gravity North -font helvetica -fill white -pointsize 14 -annotate +0+36 'version $(ALPHARELEASE)' /home/adcockm/downloads/multicore_alpha_release/versionlogo.png && \
	python3 /home/adcockm/downloads/multicore_alpha_release/bootlogo.py
endef
