; Disassembly of file: boot.o
; Mon Oct 30 00:18:26 2017
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386, privileged instructions


global _start: function

extern kernel_main                                      ; near

MBALIGN equ 00000001H                                   ; 1
MEMINFO equ 00000002H                                   ; 2
FLAGS equ 00000003H                                     ; 3
MAGIC equ 1BADB002H                                     ; 464367618
CHECKSUM equ 0E4524FFBH                                 ; -464367621


SECTION .multiboot align=4 noexecute                    ; section number 1, const

        db 02H, 0B0H, 0ADH, 1BH, 03H, 00H, 00H, 00H     ; 0000 _ ........
        db 0FBH, 4FH, 52H, 0E4H                         ; 0008 _ .OR.


SECTION .bss    align=16 noexecute                      ; section number 2, bss

stack_bottom:                                           ; byte
        resb    16384                                   ; 0000


SECTION .text   align=16 execute                        ; section number 3, code

_start: ; Function begin
        mov     esp, stack_top                          ; 0000 _ BC, 00004000(d)
        call    kernel_main                             ; 0005 _ E8, FFFFFFFC(rel)
        cli                                             ; 000A _ FA
_start.hang:
        hlt                                             ; 000B _ F4
        jmp     _start.hang                             ; 000C _ EB, FD
; _start End of function


