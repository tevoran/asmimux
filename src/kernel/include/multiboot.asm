;******************
;  Multibootheader
;******************
section .multiboot
mbh_magic equ 0x1BADB002
mbh_flags equ 0b11;Bit 0 is set to read Multibootstructure
mbh_checksum equ -(mbh_magic + mbh_flags)

align 4;required for Multibootheader
dd mbh_magic
dd mbh_flags
dd mbh_checksum
align 1;for following Code
