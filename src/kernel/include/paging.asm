;   PAGING.ASM
;
;

;global functions
global paging_init

;extern functions
extern pmm_alloc
extern print_hex

paging_init:
    ;create Pagedirectory
        ;getting location of the pagedirectory
        call pmm_alloc
	    mov cr3,eax;write offset of the pagedirectory into cr3
	    mov edi,eax;save EAX in EDI
	;activating PSE Bit for 4MiB pages
	    mov eax,cr4
	    or eax,0x10;Set the PSE Bit
	    mov cr4,eax
	;mapping the first 4MiB for the Kernel
	    ;init pagedirectoryentry for Kernel
	mov al,0x8B
	stosb
	xor ax,ax
	stosw
	stosd
	
	    ;init rest of the pagedirecty
	call init_zero_rest
	
	
	;activate paging
	mov eax,cr0
	or eax,0x80000000;set bit 31
	mov cr0,eax
ret

    ;attention this writes just zeros
    init_zero_rest:
        mov ecx,1024
	xor eax,eax
	rep stosd
    ret
    
    