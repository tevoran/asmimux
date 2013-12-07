OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH("i386")
ENTRY(start_kernel)
SECTIONS
{
    . = 0x100000 + SIZEOF_HEADERS;
    
    kernel_begin =. - SIZEOF_HEADERS;
    .multiboot :
    {
        *(.multiboot)
    }
    .text :
    {
        *(.text)
    }
    .data :
    {
	*(.data)
    }
    .bss :
    {
        *(.bss)
    }
    . = ALIGN(4096);
    kernel_end = . ;
}
