CC := mipsel-linux-gcc
OBJCOPY := mipsel-linux-objcopy
OBJDUMP := mipsel-linux-objdump

TARGETS := jz4760.rom jz4770.rom

LDFLAGS := -nostartfiles -nostdlib -mno-abicalls -EL -T linkscript.ld

.PHONY: all dump

all: $(TARGETS)

clean:
	-rm -f $(TARGETS) $(foreach target,$(TARGETS),$(basename $(target)).elf $(basename $(target).disas.txt))

%.o: %.S
	$(CC) $(ASFLAGS) $< -c -o $@

%.elf: %.o
	$(CC) $(LDFLAGS) $^ -o $@

%.rom: %.elf
	$(OBJCOPY) -O binary --remove-section=.reginfo --remove-section=.MIPS.abiflags $< $@
	grep $@ checksums.md5 |md5sum -c -

%.disas.txt: %.rom
	$(OBJDUMP) -m mips -b binary --adjust-vma=0x1fc00000 -D $< > $@
