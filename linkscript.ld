OUTPUT_ARCH(mips)
ENTRY(start)

SECTIONS
{
	. = 0x1fc00000;

	.text : { KEEP(*(.text*)) }

	. = 0x1fc01ffc;
	/*. = 0x1fc01ffc;*/

	.data1ffc : { KEEP(*(.data.1ffc*)) }
}
