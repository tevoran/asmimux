;---exceptions
;Note: The exception 9 does not exist after the i386.
    global exception0;Division by Zero
    global exception1;Debugexception
    global exception2;Non Maskable Interrupt
    global exception3;Breakpoint
    global exception4;Overflow
    global exception5;BOUND Range exceeded
    global exception6;Invalid Opcode
    global exception7;No FPU
    global exception8;Double Fault
    global exception10;Invalid TSS
    global exception11;Segment not present
    global exception12;Stack Segment Fault
    global exception13;general protection fault
    global exception14;pagefault
    global exception16;Mathfault
    global exception17;Alignment check
    global exception18;Machine check
    global exception19;SIMD Floating-Point exception
    
    extern kprint
    extern cls
    extern print_hex
    extern print_registers
    
    ;division by zero
    exception0:
    pusha
        mov ax,0x10
	mov ds,ax
	mov es,ax
	call cls
	mov esi,division_by_zero_isr
	xor bl,bl
	call kprint
    cli
    hlt
        exception0.data:
	    division_by_zero_isr db 'DIVISION BY ZERO',0

    ;debug exception
    exception1:
    pusha
        mov ax,0x10
	mov ds,ax
	mov es,ax
	call cls
	mov esi,debug_exception
	xor bl,bl
	call kprint
    cli
    hlt
        exception1.data:
	    debug_exception db 'DEBUG EXCEPTION',0

    ;non maskable interrupt
    exception2:
    pusha
        mov ax,0x10
	mov ds,ax
	mov es,ax
	call cls
	mov esi,nmi
	xor bl,bl
	call kprint
    cli
    hlt
        exception2.data:
	    nmi db 'NON MASKABLE INTERRUPT',0
    
    ;breakpoint
    exception3:
    pusha
	mov ax,0x10
	    mov ds,ax
	    mov es,ax
	call cls
	
	    mov esi,breakpoint
	    xor bl,bl
	call kprint
    cli
    hlt
    exception3.data:
        breakpoint db 'BREAKPOINT EXCEPTION',0
	
    ;Overflow
    exception4:
    pusha
	mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,overflow
	    xor bl,bl
	call kprint
    cli
    hlt
    
    exception4.data:
        overflow db 'OVERFLOW',0
	
    ;Bound Range exceeded
    exception5:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	
	call cls
	
	    mov esi,bound_range
	    xor bl,bl
	call kprint
    cli
    hlt
    
    exception5.data:
	bound_range db 'BOUND RANGE EXCEEDED',0
	
    ;invalid opcode
    exception6:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,UD
	    xor bl,bl
	call kprint
    cli
    hlt
    
    exception6.data:
        UD db 'UNDEFINED/INVALID OPCODE',0

    ;No FPU
    exception7:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,NM
	    xor bl,bl
	call kprint
    cli
    hlt
    exception7.data:
        NM db 'No FPU',0
    ;Double Fault
    exception8:
    pusha
        mov ax,0x10
	mov ds,ax
	mov es,ax
	call cls
	    mov esi,double_fault
	    xor bl,bl
	call kprint
    cli
    hlt
        exception8.data:
	    double_fault db 'DOUBLE FAULT',0
	    
    ;invalid TSS
    exception10:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,TS
	    xor bl,bl
	call kprint
    cli
    hlt
    exception10.data:
        TS db 'INVALID TASK STATE SEGMENT',0
	
    ;segment not present
    exception11:
    pusha
	mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,NP
	    xor bl,bl
	call kprint
    cli
    hlt
    exception11.data:
        NP db 'SEGMENT IS NOT PRESENT',0
	
    ;Stack Segment Fault
    exception12:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,stackfault
	    xor bl,bl
	call kprint
    cli
    hlt
    exception12.data:
        stackfault db 'STACK SEGMENT FAULT',0
	
    ;general protection fault
    exception13:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,gpf
	    xor bl,bl
	call kprint
    cli
    hlt
    exception13.data:
        gpf db 'GENERAL PROTECTION FAULT',0
	
    ;page fault
    exception14:
    pusha
        mov ax,0x10
	mov ds,ax
	mov es,ax
	call cls
	    mov esi,page_fault_text
	    xor bl,bl
	call kprint
    cli
    hlt
        exception14.data:
	    page_fault_text db "PAGE FAULT",0
	    
    ;math fault
    exception16:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,MF
	    xor bl,bl
	call kprint
    cli
    hlt
    exception16.data:
        MF db 'MATHFAULT',0
	
    ;alignment check
    exception17:
    pusha
        mov ax,0x10
            mov ds,ax
	    mov es,ax
	
	call cls
	
	    mov esi,AC
	    xor bl,bl
	call kprint
    cli
    hlt
    exception17.data:
        AC db 'ALIGNMENT CHECK',0
	
    ;machine check
    exception18:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,MC
	    xor bl,bl
	call kprint
    cli
    hlt
    exception18.data:
	MC db 'MACHINE CHECK',0
	
    ;SIMD Floating-Point exception
    exception19:
    pusha
        mov ax,0x10
	    mov ds,ax
	    mov es,ax
	    
	call cls
	
	    mov esi,XM
	    xor bl,bl
	call kprint
    cli
    hlt
    exception19.data:
        XM db 'SIMD FLOATING-POINT EXCEPTION',0