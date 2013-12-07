;    IRQs
;
;
global timer_irq
global eoi

eoi:
    push ax
        mov al,0x20;EOI Code for PIC
        out 0x20,al;send EOI Code to master PIC
        out 0xA0,al;send EOI Code to slave PIC
    pop ax
ret

timer_irq:;IRQ of the PIT
        ;end of interrupt (EOI)
	call eoi
iret
