; Disassembly of file: kernel.o
; Mon Oct 30 00:51:00 2017
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386


global kernel_main: function

extern term_writestring                                 ; near
extern term_init                                        ; near


SECTION .text   align=16 execute                        ; section number 1, code

kernel_main:; Function begin
        sub     esp, 12                                 ; 0000 _ 83. EC, 0C
        call    term_init                               ; 0003 _ E8, FFFFFFFC(rel)
        sub     esp, 12                                 ; 0008 _ 83. EC, 0C
        push    ?_001                                   ; 000B _ 68, 00000000(d)
        call    term_writestring                        ; 0010 _ E8, FFFFFFFC(rel)
        add     esp, 28                                 ; 0015 _ 83. C4, 1C
        ret                                             ; 0018 _ C3
; kernel_main End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .rodata.str1.4 align=4 noexecute                ; section number 4, const

?_001:                                                  ; byte
        db 53H, 69H, 6DH, 70H, 6CH, 65H, 20H, 4FH       ; 0000 _ Simple O
        db 53H, 20H, 56H, 65H, 72H, 73H, 69H, 6FH       ; 0008 _ S Versio
        db 6EH, 20H, 30H, 2EH, 30H, 2EH, 31H, 0AH       ; 0010 _ n 0.0.1.
        db 53H, 69H, 6EH, 20H, 48H, 69H, 6EH, 67H       ; 0018 _ Sin Hing
        db 20H, 61H, 6CH, 6CH, 20H, 72H, 69H, 67H       ; 0020 _  all rig
        db 68H, 74H, 73H, 20H, 72H, 65H, 73H, 65H       ; 0028 _ hts rese
        db 72H, 76H, 65H, 64H, 2EH, 0AH, 00H            ; 0030 _ rved...


SECTION .eh_frame align=4 noexecute                     ; section number 5, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 7CH, 08H, 01H       ; 0008 _ .zR..|..
        db 1BH, 0CH, 04H, 04H, 88H, 01H, 00H, 00H       ; 0010 _ ........
        db 1CH, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd kernel_main-$-20H                            ; 0020 _ 00000000 (rel)
        dd 00000019H, 100E4300H                         ; 0024 _ 25 269370112 
        dd 451C0E48H, 0E48200EH                         ; 002C _ 1159466568 239607822 
        dd 00000004H                                    ; 0034 _ 4 


