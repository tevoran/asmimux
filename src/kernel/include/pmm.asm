;    Physical Memory Management
;
;
;---------------
;   Section .text
;---------------
section .text
global pmm_init
global pmm_alloc
global pmm_free

;Informations for the pmm
extern multibootstructure_offset
extern kernel_begin
extern kernel_end

extern print_hex


pmm_init:  ;init routine of the pmm
    ;reading Multibootstructure
    mov ebx,dword[multibootstructure_offset];getting Offset of the Multibootstructure
        add ebx,0x08;add the offset of the mbs_upper_mem field
	
    ;get  mass of RAM to create a bitmap for each page
    mov eax,dword[ebx]; read the upper_mem in KiB
    add eax,0x400; because in the Multibootstructure is just the memory above 1 MiB in KiB
    shr eax,5;division by 4 to get the number of pages and division by 8 to get the number of bytes for the bitmap
    ;write a bit for each page 0=available/free and 1=used
    mov ecx,eax;write times of repetition in ecx to loop
    mov edi,pmm_bitmap;get Offset where the pmm bitmap is written to
        xor al,al;write in al that each page is free
    rep stosb ;creating bitmap
    
    ;set kernelpages as used
    ;get end of kernel
    mov ecx,kernel_end

    
        ;get number of used pages
        shr ecx,15; division by 4096*8  ;eax=number of bytes for used pages in PMM_BITMAP
	inc ecx; if eax is one page less than needed

    mov edi,pmm_bitmap

    
    
    ;mark the first MiB and the kernel as used
    mov al,0xFF;0xFF is that the Byte/Bits are used
    rep stosb
    
    ret
    
;-----
;     pmm_alloc
;-----
;return value of pmm_alloc
;eax=Offset of the free page
pmm_alloc:
    push esi
    push ecx
    push edi
    
    ;searching a free page
    mov esi,pmm_bitmap
    
    pmm_alloc.search:;the search loop of pmm_alloc
        lodsb
        cmp al,0xFF;if 8 Bits are set jump to pmm_alloc.search
    je pmm_alloc.search
    ;if a free page is found mark it as used an return the offset in eax
    movzx ax,al
    xor ecx,ecx
    
    pmm_alloc.set:
        bts ax,cx;mark as used
	inc cl
    jc pmm_alloc.set

    sub esi,1
    mov edi,esi
    stosb;save changes in the pmm_bitmap


    return_offset:
    mov eax,pmm_bitmap
    sub esi,eax
    shl esi,3;this is important to get the number of pages, which are in full bytes
    add esi,ecx
    shl esi,12;now you have the offset of the new page in eax
    mov eax,esi
    
    pop edi
    pop ecx
    pop esi
ret

;------------------
;PMM_FREE
;-----------------
;parameters:
;eax offset, which is in the page
pmm_free:
     push eax
     push ebx
     push ecx
     push edx
     push ebp
     push esi
     push edi

     mov edx,eax;save eax
     shr eax,15;pagenumber and Byteoffset
     shl eax,15
     sub edx,eax;get remainder
     shr eax,15
     
     mov ebp,eax
     call print_hex
     
     mov ebx,pmm_bitmap
     add eax,ebx;offset of the byte, where is written to is in eax
     mov esi,eax
     lodsb
     
         movzx ax,al
	 
     btr ax,dx;set the page as free
     
     mov edi,esi
     dec edi
     stosb
     
     pop edi
     pop esi
     pop ebp
     pop edx
     pop ecx
     pop ebx
     pop eax
ret
;------------------
;    :BSS section
;------------------
section .bss
     pmm_bitmap resb 128*1024