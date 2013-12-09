;****************
;
;           STDIO.inc
;
;****************
;CLEAR SCREEN
global cls
cls:
    push eax
    push ecx
    push edi
    xor eax,eax;set EAX to zero
    mov edi,0xB8000;set Pointer to Video RAM
            mov ecx,1000; times of repetitions of stosd
	    rep stosd; cleaning screen
    pop edi
    pop ecx
    pop eax
ret

;kprint
;esi=Offset of the C-String
;bl=line on the screen
global kprint
kprint:
    push eax
    push edi
    mov edi,0xB8000;set Pointer to Video RAM
        xor eax,eax;set eax to zero to get the Offset
        mov al,160;length of a line is 80 characters*2Bytes(one for character, one for color)
        mul bl;getting the offset of the line
    add edi,eax
    mov ah,0x02;writing color into AH to write it on the screen
	;Writing string to screen
	kprint.loop:
	    ;reading char
	    lodsb
	    test al,al;if al is zero end loop
	    jz kprint.loop.end
	    ;writing char
	    stosw
	jmp kprint.loop
	kprint.loop.end:
    pop edi
    pop eax
ret

;clear line
;clears the line in number in the register BL
global cll
cll:
    push eax
    push bx
    push edi
    push ecx
    mov al,160;the number of character * size of characters of a line
    mul bl
    mov edi,0xb8000
    movzx ebx,ax
    add edi,ebx
    xor eax,eax
    mov ecx,40
    rep stosd;clear line
    pop ecx
    pop edi
    pop bx
    pop eax
ret

;bootscreen
global bootscreen
bootscreen:
    push esi
    push ebx
    ;print screen
    mov esi,bootscreen.line1
    mov bl,1
    call kprint
    mov esi,bootscreen.line2
    mov bl,2
    call kprint
    mov esi,bootscreen.line3
    mov bl,3
    call kprint
    mov esi,bootscreen.line4
    mov bl,4
    call kprint
    mov esi,bootscreen.line5
    mov bl,5
    call kprint
    mov esi,bootscreen.line6
    mov bl,6
    call kprint
    mov esi,bootscreen.line7
    mov bl,7
    call kprint
    mov esi,bootscreen.line8
    mov bl,8
    call kprint

    ;print message
    mov esi,bootscreen.msg
    mov bl,19
    call kprint
    pop ebx
    pop esi
ret
    bootscreen.data:
        bootscreen.line1 db '                           WELCOME TO ASMIMUX',0
	bootscreen.line2 db '                                      .',0
	bootscreen.line3 db '                                     ...',0
	bootscreen.line4 db '                                    .....',0
	bootscreen.line5 db '                                   .......',0
	bootscreen.line6 db '                                  .........',0
	bootscreen.line7 db '                                 ...........',0
	bootscreen.line8 db '--------------------------------------------------------------------------------',0
	bootscreen.msg db 'latest kernel message:',0


;print_hex
;ebp=the hexnumber of edx is printed on the screen
global print_hex
print_hex:
    push ebp
    push edx
    push ebx
    push eax
    mov dh,8;times of the repitition of the loop
    mov bh,0x10;16 is the base of hexadecimal system
    rol ebp,4
    print_hex.loop:
    mov eax,ebp
        xor ah,ah;if ah is not zero ax is to big
    div bh
        mov bl,ah
        call get_hex
	    mov ax,0x0100;the printchar function of the darkblackAPI
	int 0x31
    rol ebp,4
    dec dh
    test dh,dh
    jnz print_hex.loop
    pop eax
    pop ebx
    pop edx
    pop ebp
ret
print_hex.function:
    get_hex:
            cmp bl,0x0A
	jae get_hex.ifABCDEF
	;if bl is a number not a char
	add bl,0x30
	jmp get_hex.end

	get_hex.ifABCDEF:
	    add bl,0x37

	get_hex.end:
    ret


; ksprintf function
; sprintf-style function using C calling convention
; currently supports:
; %s zero-terminated string
global ksprintf
ksprintf:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx

    mov edi, [ebp+8]


    mov esi, [ebp+12]

    xor ebx, ebx ; use for parameter count
    xor eax, eax

    .start:
        lodsb
        cmp al, 0
        je .store_end
        cmp al, '%'
        jne .store
        lodsb
        cmp al, '%'
        je .store

        ; handle parameter
        mov ecx, esi
        mov esi, [ebp+ebx*4+16]
        inc ebx

        cmp al, "s"
        je .store_string
        ;cmp al, "u"
        ;je .store_unsigned
        ;cmp al, "h"
        ;je .store_hex

        mov al, "%"
        jmp .store


    .store_string:
        .store_string.start:
            lodsb
            cmp al, 0
            je .store_string.end
            stosb
            jmp .store_string.start

        .store_string.end:
        mov esi, ecx
        jmp .start

    .store:
        stosb
        jmp .start

    .store_end:
        xor eax, eax
        stosb

    .end:
    pop ebx
    pop esi
    pop edi
    xor eax, eax
    pop ebp
    ret