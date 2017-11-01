; Disassembly of file: term.o
; Mon Oct 30 00:50:58 2017
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: Pentium Pro


global term_color
global term_buffer
global term_col
global term_row
global term_init: function
global term_setcolor: function
global term_putentryat: function
global term_putchar: function
global term_write: function
global term_writestring: function

extern strlen                                           ; near


SECTION .text   align=16 execute                        ; section number 1, code

term_init:; Function begin
        movzx   edx, byte [term_color]                  ; 0000 _ 0F B6. 15, 00000000(d)
        mov     dword [term_row], 0                     ; 0007 _ C7. 05, 00000000(d), 00000000
        mov     eax, 753664                             ; 0011 _ B8, 000B8000
        mov     dword [term_col], 0                     ; 0016 _ C7. 05, 00000000(d), 00000000
        mov     byte [term_color], 7                    ; 0020 _ C6. 05, 00000000(d), 07
        mov     dword [term_buffer], 753664             ; 0027 _ C7. 05, 00000000(d), 000B8000
        shl     edx, 8                                  ; 0031 _ C1. E2, 08
        or      edx, 20H                                ; 0034 _ 83. CA, 20
; Filling space: 9H
; Filler type: mov with same source and destination
;       db 89H, 0F6H, 8DH, 0BCH, 27H, 00H, 00H, 00H
;       db 00H

ALIGN   16
?_001:  mov     word [eax], dx                          ; 0040 _ 66: 89. 10
        add     eax, 2                                  ; 0043 _ 83. C0, 02
        cmp     eax, 757664                             ; 0046 _ 3D, 000B8FA0
        jnz     ?_001                                   ; 004B _ 75, F3
        DB      0F3H                                    ; Prefix coded explicitly
        ret                                             ; 004D _ F3: C3
; term_init End of function

        nop                                             ; 004F _ 90

ALIGN   16
term_setcolor:; Function begin
        mov     eax, dword [esp+4H]                     ; 0050 _ 8B. 44 24, 04
        mov     byte [term_color], al                   ; 0054 _ A2, 00000000(d)
        ret                                             ; 0059 _ C3
; term_setcolor End of function

; Filling space: 6H
; Filler type: lea with same source and destination
;       db 8DH, 0B6H, 00H, 00H, 00H, 00H

ALIGN   8

term_putentryat:; Function begin
        movzx   edx, byte [esp+8H]                      ; 0060 _ 0F B6. 54 24, 08
        mov     eax, dword [esp+10H]                    ; 0065 _ 8B. 44 24, 10
        lea     eax, [eax+eax*4]                        ; 0069 _ 8D. 04 80
        mov     ecx, edx                                ; 006C _ 89. D1
        movzx   edx, byte [esp+4H]                      ; 006E _ 0F B6. 54 24, 04
        shl     ecx, 8                                  ; 0073 _ C1. E1, 08
        shl     eax, 4                                  ; 0076 _ C1. E0, 04
        add     eax, dword [esp+0CH]                    ; 0079 _ 03. 44 24, 0C
        or      edx, ecx                                ; 007D _ 09. CA
        mov     ecx, dword [term_buffer]                ; 007F _ 8B. 0D, 00000000(d)
        mov     word [ecx+eax*2], dx                    ; 0085 _ 66: 89. 14 41
        ret                                             ; 0089 _ C3
; term_putentryat End of function

; Filling space: 6H
; Filler type: lea with same source and destination
;       db 8DH, 0B6H, 00H, 00H, 00H, 00H

ALIGN   8

term_putchar:; Function begin
        push    esi                                     ; 0090 _ 56
        push    ebx                                     ; 0091 _ 53
        movzx   ebx, byte [term_color]                  ; 0092 _ 0F B6. 1D, 00000000(d)
        mov     ecx, dword [term_row]                   ; 0099 _ 8B. 0D, 00000000(d)
        mov     edx, dword [term_col]                   ; 009F _ 8B. 15, 00000000(d)
        lea     eax, [ecx+ecx*4]                        ; 00A5 _ 8D. 04 89
        mov     esi, ebx                                ; 00A8 _ 89. DE
        movzx   ebx, byte [esp+0CH]                     ; 00AA _ 0F B6. 5C 24, 0C
        shl     esi, 8                                  ; 00AF _ C1. E6, 08
        shl     eax, 4                                  ; 00B2 _ C1. E0, 04
        add     eax, edx                                ; 00B5 _ 01. D0
        add     edx, 1                                  ; 00B7 _ 83. C2, 01
        or      ebx, esi                                ; 00BA _ 09. F3
        mov     esi, dword [term_buffer]                ; 00BC _ 8B. 35, 00000000(d)
        cmp     edx, 80                                 ; 00C2 _ 83. FA, 50
        mov     word [esi+eax*2], bx                    ; 00C5 _ 66: 89. 1C 46
        jz      ?_002                                   ; 00C9 _ 74, 15
        pop     ebx                                     ; 00CB _ 5B
        mov     dword [term_col], edx                   ; 00CC _ 89. 15, 00000000(d)
        pop     esi                                     ; 00D2 _ 5E
        ret                                             ; 00D3 _ C3

; Filling space: 0CH
; Filler type: lea with same source and destination
;       db 8DH, 0B6H, 00H, 00H, 00H, 00H, 8DH, 0BFH
;       db 00H, 00H, 00H, 00H

ALIGN   16
?_002:  add     ecx, 1                                  ; 00E0 _ 83. C1, 01
        mov     eax, 0                                  ; 00E3 _ B8, 00000000
        mov     dword [term_col], 0                     ; 00E8 _ C7. 05, 00000000(d), 00000000
        cmp     ecx, 25                                 ; 00F2 _ 83. F9, 19
        cmove   ecx, eax                                ; 00F5 _ 0F 44. C8
        pop     ebx                                     ; 00F8 _ 5B
        mov     dword [term_row], ecx                   ; 00F9 _ 89. 0D, 00000000(d)
        pop     esi                                     ; 00FF _ 5E
        ret                                             ; 0100 _ C3
; term_putchar End of function

        jmp     term_write                              ; 0101 _ EB, 0D

        nop                                             ; 0103 _ 90
        nop                                             ; 0104 _ 90
        nop                                             ; 0105 _ 90
        nop                                             ; 0106 _ 90
        nop                                             ; 0107 _ 90
        nop                                             ; 0108 _ 90
        nop                                             ; 0109 _ 90
        nop                                             ; 010A _ 90
        nop                                             ; 010B _ 90
        nop                                             ; 010C _ 90
        nop                                             ; 010D _ 90
        nop                                             ; 010E _ 90
        nop                                             ; 010F _ 90

ALIGN   16
term_write:; Function begin
        push    esi                                     ; 0110 _ 56
        push    ebx                                     ; 0111 _ 53
        mov     esi, dword [esp+10H]                    ; 0112 _ 8B. 74 24, 10
        test    esi, esi                                ; 0116 _ 85. F6
        jz      ?_004                                   ; 0118 _ 74, 17
        mov     ebx, dword [esp+0CH]                    ; 011A _ 8B. 5C 24, 0C
        add     esi, ebx                                ; 011E _ 01. DE
?_003:  movsx   eax, byte [ebx]                         ; 0120 _ 0F BE. 03
        add     ebx, 1                                  ; 0123 _ 83. C3, 01
        push    eax                                     ; 0126 _ 50
        call    term_putchar                            ; 0127 _ E8, FFFFFFFC(rel)
        cmp     esi, ebx                                ; 012C _ 39. DE
        pop     eax                                     ; 012E _ 58
        jnz     ?_003                                   ; 012F _ 75, EF
?_004:  pop     ebx                                     ; 0131 _ 5B
        pop     esi                                     ; 0132 _ 5E
        ret                                             ; 0133 _ C3
; term_write End of function

; Filling space: 0CH
; Filler type: lea with same source and destination
;       db 8DH, 0B6H, 00H, 00H, 00H, 00H, 8DH, 0BFH
;       db 00H, 00H, 00H, 00H

ALIGN   16

term_writestring:; Function begin
        push    esi                                     ; 0140 _ 56
        push    ebx                                     ; 0141 _ 53
        sub     esp, 16                                 ; 0142 _ 83. EC, 10
        mov     ebx, dword [esp+1CH]                    ; 0145 _ 8B. 5C 24, 1C
        push    ebx                                     ; 0149 _ 53
        call    strlen                                  ; 014A _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 014F _ 83. C4, 10
        test    eax, eax                                ; 0152 _ 85. C0
        jz      ?_006                                   ; 0154 _ 74, 20
        lea     esi, [ebx+eax]                          ; 0156 _ 8D. 34 03
; Filling space: 7H
; Filler type: lea with same source and destination
;       db 8DH, 0B4H, 26H, 00H, 00H, 00H, 00H

ALIGN   8
?_005:  movsx   edx, byte [ebx]                         ; 0160 _ 0F BE. 13
        sub     esp, 12                                 ; 0163 _ 83. EC, 0C
        add     ebx, 1                                  ; 0166 _ 83. C3, 01
        push    edx                                     ; 0169 _ 52
        call    term_putchar                            ; 016A _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 016F _ 83. C4, 10
        cmp     esi, ebx                                ; 0172 _ 39. DE
        jnz     ?_005                                   ; 0174 _ 75, EA
?_006:  add     esp, 4                                  ; 0176 _ 83. C4, 04
        pop     ebx                                     ; 0179 _ 5B
        pop     esi                                     ; 017A _ 5E
        ret                                             ; 017B _ C3
; term_writestring End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .eh_frame align=4 noexecute                     ; section number 4, const

        db 14H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0000 _ ........
        db 01H, 7AH, 52H, 00H, 01H, 7CH, 08H, 01H       ; 0008 _ .zR..|..
        db 1BH, 0CH, 04H, 04H, 88H, 01H, 00H, 00H       ; 0010 _ ........
        db 10H, 00H, 00H, 00H, 1CH, 00H, 00H, 00H       ; 0018 _ ........
        dd term_init-$-20H                              ; 0020 _ 00000000 (rel)
        dd 0000004FH, 00000000H                         ; 0024 _ 79 0 
        dd 00000010H, 00000030H                         ; 002C _ 16 48 
        dd term_init-$+1CH                              ; 0034 _ 00000050 (rel)
        dd 0000000AH, 00000000H                         ; 0038 _ 10 0 
        dd 00000010H, 00000044H                         ; 0040 _ 16 68 
        dd term_init-$+18H                              ; 0048 _ 00000060 (rel)
        dd 0000002AH, 00000000H                         ; 004C _ 42 0 
        dd 0000002CH, 00000058H                         ; 0054 _ 44 88 
        dd term_init-$+34H                              ; 005C _ 00000090 (rel)
        dd 00000071H, 080E4100H                         ; 0060 _ 113 135151872 
        dd 0E410286H, 7A03830CH                         ; 0068 _ 239141510 2047050508 
        dd 080EC30AH, 040EC647H                         ; 0070 _ 135185162 68077127 
        dd 0C3590B4DH, 0C647080EH                       ; 0078 _ -1017574579 -968423410 
        dd 0000040EH, 00000028H                         ; 0080 _ 1038 40 
        dd 00000088H                                    ; 0088 _ 136 
        dd term_init-$+84H                              ; 008C _ 00000110 (rel)
        dd 00000024H, 080E4100H                         ; 0090 _ 36 135151872 
        dd 0E410286H, 5503830CH                         ; 0098 _ 239141510 1426293516 
        dd 0E48100EH, 0EC3430CH                         ; 00A0 _ 239603726 247677708 
        dd 0EC64108H, 00000004H                         ; 00A8 _ 247873800 4 
        dd 00000034H, 000000B4H                         ; 00B0 _ 52 180 
        dd term_init-$+88H                              ; 00B8 _ 00000140 (rel)
        dd 0000003CH, 080E4100H                         ; 00BC _ 60 135151872 
        dd 0E410286H, 4303830CH                         ; 00C4 _ 239141510 1124303628 
        dd 0E451C0EH, 100E4820H                         ; 00CC _ 239410190 269371424 
        dd 441C0E54H, 0E48200EH                         ; 00D4 _ 1142689364 239607822 
        dd 0C0E4710H, 080EC341H                         ; 00DC _ 202262288 135185217 
        dd 040EC641H                                    ; 00E4 _ 68077121 


