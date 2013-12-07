;---IDT
;NOTE: The exception 9 does not exist after the i386. 
;NOTE2: The exception 15 is reserved.
section .text
extern exception0
extern exception1
extern exception2
extern exception3
extern exception4
extern exception5
extern exception6
extern exception7
extern exception8
extern exception10
extern exception11
extern exception12
extern exception13
extern exception14
extern exception16
extern exception17
extern exception18
extern exception19
extern darkblack
extern timer_irq
extern keyboard_irq
extern floppy_irq

global create_idt
create_idt:
    lidt [idtp];reading IDT
    ;setting up IDT
        ;exception0
        mov ebp,exception0
        xor ecx,ecx
        mov bl,0xEE
    call create_isr
    
        ;exception1
	mov ebp,exception1
	mov ecx,1;to create Interrupt 1
	mov bl,0xEE
    call create_isr
    
        ;exception2
	mov ebp,exception2
	mov ecx,2;to create Interrupt 2
	mov bl,0xEE
    call create_isr
    
        ;breakpointexception
	mov ebp,exception3
	mov ecx,3;number 3
	mov bl,0xEE
    call create_isr
    
        ;Overflowexception
	mov ebp,exception4
	mov ecx,4;number 4
	mov bl,0xEE
    call create_isr
    
        ;Bound range exceeded
	mov ebp,exception5
	mov ecx,5;number 5
	mov bl,0xEE
    call create_isr
    
        ;invalid opcode
	mov ebp,exception6
	mov ecx,6;number6
	mov bl,0xEE
    call create_isr
    
        ;No FPU
	mov ebp,exception7
	mov ecx,7;number 7
	mov bl,0xEE
    call create_isr
    
        ;double fault
	mov ebp,exception8
	mov ecx,8
	mov bl,0xEE
    call create_isr
    
       ;invalid TSS
       mov ebp,exception10
       mov ecx,10;number 10
       mov bl,0xEE
    call create_isr
    
        ;segment nor present
	mov ebp,exception11
	mov ecx,11;exception 11
	mov bl,0xEE
    call create_isr
    
        ;stack segment fault
	mov ebp,exception12
	mov ecx,12;exception 12
	mov bl,0xEE
    call create_isr
    
        ;general protection fault
	mov ebp,exception13
	mov ecx,13;exception 13
	mov bl,0xEE
    call create_isr
    
        ;page fault
	mov ebp,exception14
	mov ecx,14
	mov bl,0xEE
    call create_isr
    
        ;mathfault
	mov ebp,exception16
	mov ecx,16
	mov bl,0xEE
    call create_isr
    
        ;alignment check
	mov ebp,exception17
	mov ecx,17
	mov bl,0xEE
    call create_isr
    
        ;machine check
	mov ebp,exception18
	mov ecx,18
	mov bl,0xEE
    call create_isr
    
        ;SIMD Floating-Point Exception
	mov ebp,exception19
	mov ecx,19
	mov bl,0xEE
    call create_isr
    
        ;IRQ 0 (timer_irq)
	mov ebp,timer_irq
	mov ecx,0x20
	mov bl,0xEE
    call create_isr
    
        ;IRQ 1(keyboard irq)
	mov ebp,keyboard_irq
	mov ecx,0x21
	mov bl,0xEE
    call create_isr
    
        ;IRQ 6 (floppy irq)
	mov ebp,floppy_irq
	mov ecx,0x26
    call create_isr
    
        ;darkblackAPI
	mov ebp,darkblack
	mov ecx,0x31
	mov bl,0xEE
    call create_isr
ret

;EBP=Offset of the interrupthandler
;ECX=number of interrupt    (zero is the first int)
;BL=Attributebyte
create_isr:
    push eax
    push edi
        mov eax,8
	mul cl  ;cl*al is in ax
	
	mov edi,idt;getting the offset, where to write the idt entry
	add edi,eax
	
	;writing the first 16 bit of the offset of the ISR
	mov eax,ebp
	stosw
	;write codeselektor
	mov ax,0x8
	stosw
	;writing a byte that is ignored^^
	xor al,al
	stosb
	;writing Attributebyte
	mov al,bl
	stosb
	;the other 16 bit of the offset
	mov eax,ebp
	shr eax,16
	stosw
    pop edi
    pop eax
ret

section .data
idtp:    ;Pointer to the IDT structure
    dw 0x7FF;256 Interrupts
    dd idt

section .bss
idt resb 256*8
