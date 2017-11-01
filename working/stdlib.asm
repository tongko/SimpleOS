; Disassembly of file: stdlib.o
; Mon Oct 30 00:50:55 2017
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386


global strlen: function


SECTION .text   align=16 execute                        ; section number 1, code

strlen: ; Function begin
        mov     edx, dword [esp+4H]                     ; 0000 _ 8B. 54 24, 04
        xor     eax, eax                                ; 0004 _ 31. C0
; Filling space: 0AH
; Filler type: lea with same source and destination
;       db 8DH, 76H, 00H, 8DH, 0BCH, 27H, 00H, 00H
;       db 00H, 00H

ALIGN   16
?_001:  add     eax, 1                                  ; 0010 _ 83. C0, 01
        cmp     byte [edx+eax-1H], 0                    ; 0013 _ 80. 7C 02, FF, 00
        jnz     ?_001                                   ; 0018 _ 75, F6
        DB      0F3H                                    ; Prefix coded explicitly
        ret                                             ; 001A _ F3: C3
; strlen End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .eh_frame align=4 noexecute                     ; section number 4, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 7CH, 08H, 01H       ; 0008 _ .zR..|..
        db 1BH, 0CH, 04H, 04H, 88H, 01H, 00H, 00H       ; 0010 _ ........
        db 10H, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd strlen-$-20H                                 ; 0020 _ 00000000 (rel)
        dd 0000001CH, 00000000H                         ; 0024 _ 28 0 


