;GERMAN KEYBOARD LAYOUT OF THE ASMIMUX KEYBOARDDRIVER
;
;

;if something has no ASCII Code then the Errorcode 0xFF is given as return value
section .data
;global variables
global scancode_ger

;variables
scancode_ger:
    db 0;dummy
    db 0xFF;ESC
    db "1";1
    db "2";2
    db "3";3
    db "4";4
    db "5";5
    db "6";6
    db "7";7
    db "8";8
    db "9";9
    db "0";0
    db "?";ß
    db "`";`
    db 0xFF;Backspace
    db 0xFF;Tab
    db "Q";Q
    db "W";W
    db "E";E
    db "R";R
    db "T";T
    db "Z";Z
    db "U";U
    db "I";I
    db "O";O
    db "P";P
    db "Ü";Ü
    db "+";+
    db 0xFF;return
    db 0xFF;left crtl
    db "A";A
    db "S";S
    db "D";D
    db "F";F
    db "G";G
    db "H";H
    db "J";J
    db "K";K
    db "L";L
    db "Ö";Ö
    db "Ä";Ä
    db "°";^
    db 0xFF;left shift
    db "#";#
    db "Y";Y
    db "X";X
    db "C";C
    db "V";V
    db "B";B
    db "N";N
    db "M";M
    db ",";,
    db ".";.
    db "-";-
    db 0xFF;right shift
    db "*";*
    db 0xFF;left ALT
    db " ";space
    db 0xFF;shift lock
    db 0xFF; F1
    db 0xFF; F2
    db 0xFF; F3
    db 0xFF; F4
    db 0xFF; F5
    db 0xFF; F6
    db 0xFF; F7
    db 0xFF; F8
    db 0xFF; F9
    db 0xFF; F10
    db 0xFF; Numlock
    db 0xFF; Rollen
    db "7";7
    db "8";8
    db "9";9
    db "-";-
    db "4";4
    db "5";5
    db "6";6
    db "+";+
    db "1";1
    db "2";2
    db "3";3
    db "0";0
    db ",";,
    db ">";<
    db 0xFF;F11
    db 0xFF;F12