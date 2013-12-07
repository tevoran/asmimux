;
;      PIC function
;
global PIC

PIC:
    .init: ;reset the PIC
            mov al,0x11;byte to init pic
	out 0x20,al;write initbyte to master PIC
	    ;Writing ICW Bytes into Port
		mov al,0x20;Set IRQs to Interrupt 0x20+
		out 0x21,al
		    nop
		mov al,0x04
		out 0x21,al
		    nop
		mov al,0x01;set PIC to 8086 Mode
		out 0x21,al
	    
	    mov al,0x11;byte to init pic
	out 0xA0,al;write initbyte to slave PIC
	    ;writing ICW Bytes into Port
	        mov al,0x28;Set IRQs to interrupt 0x28+
		out 0xA1,al
		    nop
		mov al,0x02
		out 0xA1,al
		    nop
		mov al,0x01;Set PIC to 8086 Mode
		out 0xA1,al
		
ret
