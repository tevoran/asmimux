;---GDT
section .data
global gdtp
	gdt:
	        ;the zero descriptor (noone knows the meaning of this selector)
		nulldescriptor:;(8 zero bytes)
			db 0
			db 0
			db 0
			db 0
			
			db 0
			db 0
			db 0
			db 0
		;the kernel codeselektor
		kernel_codesegment:
			dw 0xFFFF	;Limit
			dw 0		;Base
			
			db 0		;Base
			db 10011010b;Accessbyte
			db 11001111b;Flags and Limit
			db 0	;Base
		;the kernel datasegment, for stack, data and things like that
		kernel_datasegment:
			dw 0xFFFF	;Limit
			dw 0	;Base
			
			db 0	;Base
			db 10010010b;Accessbyte
			db 11001111b;Flags and Limit
			db 0	;Base
		;the userspace codeselektor
		userspace_codesegment:
		        dw 0xFFFF    ;Limit
			dw 0        ;Base
		
		        db 0        ;Base
			db 11110010b;Accessbyte
			db 11001111b;Flags and Limit
			db 0	;Base
		;the userspace dataselector
		userspace_datasegment:
			dw 0xFFFF	;Limit
			dw 0	;Base
			
			db 0	;Base
			db 11110010b;Accessbyte
			db 11001111b;Flags and Limit
			db 0	;Base
	gdt_end:
	
	gdtp:
		;limit:
		dw gdt_end-gdt-1
		;base:
		dd gdt
		
