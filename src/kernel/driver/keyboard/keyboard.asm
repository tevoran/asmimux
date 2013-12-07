;    the keyboarddriver of ASMIMUX
;
;
;global function
global keyboard_irq
global keyboard_init
;extern function
extern eoi
extern print_hex

;extern variables
extern scancode
extern ascii.api
extern scancode_ger

;the irq handler for the idt
keyboard_irq:
        in al,0x60
	    ;test if the irq was sended, by the keyboad when the key was stopped to press down
	    sub al,[scancode]
	    cmp al,0x80
	    je   keyboard_irq_end
	    
	    add al,[scancode]
	    mov [scancode],al;save the key for the darkblackAPI function
	;get the ASCII value of the Scancode
	movzx ebx,al;get the Pointer
	mov al,byte[scancode_ger+ebx]
	mov byte[ascii.api],al
	;print the ascii sign on screen
		mov bl,al
		mov ax,0x0100
		int 0x31
		
	keyboard_irq_end:
        call eoi;it is important to send the eoi signal to the pic
    iret

;the init code for the keyboard
keyboard_init:
    call keyboard.check
    ;let the leds shine^^
        mov al,0xED
    out 0x60,al
        mov al,0x7
    out 0x60,al;let the leds shine
    
    call keyboard.check
    ;reset the keyboard
        mov al,0xF4
    out 0x60,al
ret

keyboard.check:
    keyboard.check.loop:
        in al,0x64
	bt ax,1;test bit 1
    jc keyboard.check.loop
ret
