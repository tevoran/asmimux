; Floppy Device Driver of TevOpSys
;
;
section .text
;global function
global init_isa_dma ;the ISA DMA Controller is just used for the floppy disk, this is the reason, why it is in this file
global floppy_init
global floppy_irq;the irq routine
global lsn
global floppy_read

;extern functions
extern kprint
extern cll
extern print_hex
extern pmm_alloc
extern eoi

;global variables
global ready

;definitions
%define SRA 0x3F0 ;Status Register A
%define SRB 0x3F1 ;Status Register B
%define DOR 0x3F2 ;Digital Output Register
%define TDR 0x3F3 ;Tape drive register
%define MSR 0x3F4 ;Main status register
%define  DRSR 0x3F4 ;Date rate select register
%define DR 0x3F5 ;Data register
%define DIR 0x3F7 ;digital input register
%define CCR 0x3F7 ;configuration control register
init_isa_dma:
        ;write Message on the screen
            mov esi,init_dma_text
	    mov bl,20
	    call cll
	call kprint
	
	;init ISA DMA
	    ;reset ISA Controller Master and Slave
	    xor al,al
	    out 0xDA,al ;reset Master
	    out 0x0D,al ;reset Slave
	
	    ;activate ISA Controller Master and Slave
	    ;al is still zero (IMPORTANT)
	    out 0xD0,al ;activate Master
	    out 0x08,al ;activate Slave
	    
	    ;unmask (deactivate) all Channels
	    mov al,0x07;set each channel as unmasked
	    out 0xDE,al ;unmask all master channels
	    out 0x0F,al ;unmask all slave channels
	    
	;write successmessage on the screen
	    mov esi,init_dma_ready
	    mov bl,20
	    call cll
	call kprint
    ret

floppy_init:
	;write message to the screen
            mov esi,init_floppy
	    mov bl,20
	    call cll
	call kprint
	
	;init floppy
	    mov dx,DOR
	    mov al,0xF8; start each Motor, use DMA, select Disk 0, reset the FDC
	out dx,al
	
	;read the data register
	    ;mov dx,DR
	    ;in al,dx;first time
	    ;in al,dx
	    ;in al,dx;second time
	    ;in al,dx
	    ;in al,dx;third time
	    ;in al,dx
	    ;in al,dx;fourth time
	    ;in al,dx
	
	    mov dx,CCR
	    mov al,0x3 ;use the highest possible speed (1MBit)
	out dx,al
	
	    mov esi,floppy_ready_text
	    mov bl,20
	call cll
	call kprint
	ret

;TODO
;reads a sector, which is given in LSN in the three LSN Variables, so that you have first run the LSN function and loads it to the offset, which is returned in EAX
;LIMITATION: the driver can just use floppydrive 0 (or for Windowsuser A: )
floppy_read:
            ;prepare the use of the Floppy
	        ;read the main status register
		floppy_read.loop:
		    mov dx,MSR
		    in al,dx
		    bt ax,8
		    jnc floppy_read.loop;if fdc is ready go on with reading a sector
		    
		;prepare the DMA access
		    ;unmask all unused DMA channels
		    ;first unmask all master dma connections
		        mov al,0x0F
		    out 0xDE,al
		    ;ummask all unused slave connections
		        mov al,0b00001011
		    out 0x0A,al
		 
		    
		    ;set the offset, where the data is written in the RAM
		    call pmm_alloc ;get an free offset in EAX
		    
		    mov ebx,eax;save eax in ebx
	            ;use the flip flop
		        xor al,al
		    out 0x0C,al
		    
		    ;send the first part of the offset
		    mov eax,ebx
		    out 0x04,al
		    ;send the second part of the offset
		    shr eax,8
		    out 0x04,al
		    
		;set the floppy_ready variable to zero
		mov bl,byte[floppy_ready]
		xor bl,bl
		mov byte[floppy_ready],bl
		
		;prepare the Motor of the Floppydrive
		mov dx,DR;select the DATA REGISTER
		    mov al,0x4;move motor to the cylinder, which was computed
		out dx,al
		    ;select the drive and the head
		    mov al,byte[chs_head]
		    shl al,2;the FDC needs this information at this bitoffset
		out dx,al
		    ;select the cylinder
		    mov al,byte[chs_cylinder]
		out dx,al
		
		;wait until the movement is over
                floppy_read.wait_motor:
		    mov al,byte[floppy_ready]
		    		    movzx ebp,al
		    call print_hex
		    push ax
		    mov ax,0x101
		    int 0x31
		    pop ax
		    cmp al,1
		jnz floppy_read.wait_motor
		
		;print a successmessage
		    mov esi,motor_has_moved
		    mov bl,20
		    call cll
		call kprint

        ret

;CHS2LSN function
;ecx is the input
;the return values are in three variables, which are overgiven to the floppy_read and the floppy_write functions
lsn:
        ;preparations
	mov eax,ecx
	xor edx,edx
	;Cylinder
	mov ebx,18*2;sectors per track * heads
	div ebx; eax:edx/ebx in eax ,rest in edx 
	mov byte[chs_cylinder],al;save the result
	;Head
	mov eax,edx;mov the rest of the division above into eax
	mov ebx,18;sectors per track
	div ebx; eax:edx/ebx in eax ,rest in edx 
	mov byte[chs_head],al;save the result
	;Sector
	add edx,1; increment edx per 1
	mov byte[chs_sector],dl;save the result
    ret
floppy_irq:
        push eax
	push es
	push ds
	
            mov ax,0x10
	    mov es,ax
	    mov ds,ax
	
	    ;i have to do this ;)
	    mov dx,DR
	        mov al,0x8;interrupt check function of the FDC
	    out dx,al
	    
	    in al,dx; read the result
	    
	    ;tell the the floppy driver that the DMA transfer  has end
	    mov al,1
	    mov byte[floppy_ready],al

	pop ds
	pop es
	pop eax
        call eoi;tell the pic that the irq was handled
    iret

;interrupt check
;this is an important function to check the FDC if it is ready
interrupt_check:
        mov dx,DR
	mov al,0x8;the check function
	interrupt_check.wait:
	    
	jmp interrupt_check.wait
    ret
section .data
    init_dma_text db "init ISA DMA",0
    init_dma_ready db "ISA DMA ready",0
    init_floppy db "init FLOPPY DRIVE",0
    floppy_ready_text db 'FLOPPY DRIVE is ready now',0
    motor_has_moved db 'FLOPPY MOTOR HAS MOVED',0
   

section .bss
     floppy_ready resb 1
     chs_cylinder resb 1
     chs_head resb 1
     chs_sector resb 1
