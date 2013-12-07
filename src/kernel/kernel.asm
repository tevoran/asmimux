;**************************
;Kernel
;**************************
[bits 32]
;global variables
global multibootstructure_offset

;extern functions
extern kprint
extern cls
extern cll
extern create_idt
extern PIC
extern pmm_init
extern pmm_alloc
extern pmm_free
extern print_hex
extern paging_init
extern keyboard_init
extern bootscreen
extern init_isa_dma
extern floppy_init
extern floppy_read
extern lsn

;extern variables
extern gdtp
;global functions
global start_kernel

;-----------------
;Multibootsection
;-----------------
section multiboot


;-----------------
;    .TEXT section
;-----------------
section .text 
start_kernel:   ;<----- Entry Point to execute kernel
;get the Position of the Multibootstructure
mov dword[multibootstructure_offset],ebx
;Setting up GDT
cli;i dont want to have any problems^^
lgdt[gdtp];loading GDT
    mov ax,0x10;changing Datasegments
    mov ds,ax
    mov es,ax
jmp 0x8:new_gdt;jump to use the new GDT

new_gdt:
    mov esi,gdt_ok;writing MSG that GDT is ok
    mov bl,20
    call cll
call kprint

;setting up IDT
    mov esi,loading_idt
    mov bl,20
call kprint

call create_idt; creating the idt
sti;enable interrupts

    mov esi,idt_ok
    mov bl,20
    call cll
call kprint
call cls
call bootscreen;print bootscreen on the screen
;programming PIC
    mov esi,programming_pic
    mov bl,20
    call cll
call kprint

call PIC ;remapping IRQs

    mov esi,pic_programmed
    mov bl,20
    call cll
call kprint

;init FPU
finit;init FPU
    mov esi,init_fpu
    mov bl,20
    call cll
call kprint
;starting the pmm
    mov esi,pmm_text
    mov bl,20
    call cll
call kprint

    call pmm_init

    mov esi,pmm_ready
    mov bl,20
    call cll
call kprint

;starting paging
    mov esi,paging_text_init
    mov bl,20
    call cll
call kprint

    call paging_init

    mov esi,paging_ready
    mov bl,20
    call cll
call kprint

;init keyboard
    mov esi,keyboard_init_text
    mov bl,20
    call cll
call kprint

    call keyboard_init
    
    mov esi,keyboard_init_ready
    mov bl,20
    call cll
call kprint
;init Floppy
call init_isa_dma
call floppy_init
mov edx,0x00000010
call lsn
;call floppy_read


jmp $
end_kernel:

;------------------
;     .DATA section
;------------------
section .data
    gdt_ok db 'GDT was loaded successfully',0
    loading_idt db 'IDT is loading now',0
    idt_ok db 'IDT was loaded and ISRs, EXCEPTIONS and the darkblackAPI are installed',0
    programming_pic db 'programming PIC',0
    pic_programmed db 'PIC was programmed',0
    init_fpu db 'FPU is ready',0
    pmm_text db 'starting PHYSICAL MEMORY MANAGEMENT',0
    pmm_ready db 'PHYSICAL MEMORY MANAGEMENT is ready',0
    paging_text_init db 'starting PAGING',0
    paging_ready db 'mapped 4MiB RAM',0
    keyboard_init_text db 'init KEYBOARD',0
    keyboard_init_ready db 'KEYBOARD ready',0
    
    ;----Variables
    multibootstructure_offset dd 0
    