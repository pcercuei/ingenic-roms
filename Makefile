CC := mipsel-linux-gcc
OBJCOPY := mipsel-linux-objcopy
OBJDUMP := mipsel-linux-objdump

TARGETS := jz4760.rom

LDFLAGS := -nostartfiles -nostdlib -mno-abicalls -EL -T linkscript.ld

.PHONY: all dump

all: $(TARGETS)

clean:
	-rm -f $(TARGETS) $(basename $(TARGETS)).elf $(basename $(TARGETS)).disas.txt

%.o: %.S
	$(CC) $(ASFLAGS) $< -c -o $@

%.elf: %.o
	$(CC) $(LDFLAGS) $^ -o $@

%.rom: %.elf
	$(OBJCOPY) -O binary --remove-section=.reginfo --remove-section=.MIPS.abiflags $< $@
	md5sum -c $(@).md5

%.disas.txt: %.rom
	$(OBJDUMP) -m mips -b binary --adjust-vma=0x1fc00000 -D $< > $@
