;The tevOpSys implementation of the darkblackAPI
;
;
;extern functions
extern kprint
extern cls

;global functions
global darkblack

;global variables
global scancode
global ascii.api
section .text
darkblack:
        push bp
        mov bp,0x10
	mov ds,bp
	mov es,bp
	pop bp
        ;checking the functionnumber
	cmp ah,0x00;0x00 is for the operations of a process
        jz ah00
	
        cmp ah,0x01;0x01 is for CLI based functions
	jz ah01
	
	cmp ah,0x04;0x04 is for Keyboard functions
	jz ah04
	
	cmp ah,0x23;0x23 is for memoryfunctions
	jz ah23
    darkblack.end:;end of darkblackfunction
iret

ah00:
cmp al,0x01
jz ah00.al01

jmp darkblack.end

ah01:
cmp al,0x00;0x00 is the printcharfunction
jz ah01.al00

cmp al,0x01;cls function
jz ah01.al01

ah04:
cmp al,0x00;get the scancode
jz ah04.al00

ah23:
cmp al,0x00		;memset function
jz ah23.al00

cmp al,0x01		;memcopy
jz ah23.al01

cmp al,0x02		;memcmp
jz ah23.al02

ah23.al00:	;setze ecx bytes startend bei edi auf den wert von ebx
        cld
	mov eax,ebx
	rep stosb
	jmp darkblack.end

ah23.al01:			;kopiert ecx bytes von esi nach edi
	cld
	rep movsb
	jmp darkblack.end
	
ah23.al02:		;vergleicht ecx bytes von edi mit esi, 1 in eax wenn gleich, 0 ungleich
	cld
	repe cmpsb
	je equal
	mov eax,0x0
	jmp quit
	equal:
	mov eax,0x1
	quit:
	jmp darkblack.end

jmp darkblack.end

    ;taskchange
    ah00.al01:
        int 0x20;execute timer_irq

    ;Printchar
    ah01.al00:
        ;getting offset to write to
	mov edi,0xB8000;Pointer to Video RAM
	    movzx ecx,word[textpointer]
	add edi,ecx
	    mov al,bl;loading Byte to EAX to write it on the screen
	stosb
	    mov al,0x02;write the Colorbyte into al
	stosb
	    add ecx,2
	    mov word[textpointer],cx;write the actual position into the variable textpointer
    jmp darkblack.end


    ;CLS
    ah01.al01:
    push ax
        mov ax,word[textpointer]
	xor ax,ax
	mov word[textpointer],ax
    pop ax
        call cls
	jmp darkblack.end
	
    ;get scancode
    ah04.al00:
    mov bl,byte[scancode]
    jmp darkblack.end
    
    ;get ascii code
    ah04.al01:
    mov bl,byte[ascii.api]
    jmp darkblack.end

section .data
data:
section .bss
bss:
    textpointer resb 2
    scancode resb 1
    ascii.api resb 1
