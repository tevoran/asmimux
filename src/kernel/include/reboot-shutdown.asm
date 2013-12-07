; the shutdown and reboot manager of ASMIMUX
;
;
;

global reboot




;no argument
reboot:
	mov al,0xFE
	out 0x64,al