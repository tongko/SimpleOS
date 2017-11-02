[bits 32]

VGA_WIDTH   equ 80
VGA_HEIGHT  equ 25

global term_buffer
global term_col
global term_row
global _term_init:function (_term_init.end - _term_init)                        ; void _term_init(void)
global _term_setcolor:function (_term_setcolor.end - _term_setcolor)            ; void _term_setcolor(char)
global _term_putentryat:function (_term_putentryat.end - _term_putentryat)      ; void _term_putentryat(char, char, dword, dword)
global _term_putchar:function (_term_putchar.end - _term_putchar)               ; void _term_putchar(char)
global _term_write:function (_term_write.end - _term_write)                     ; void _term_write(char*, dword)
global _term_writestring:function (_term_writestring.end - _term_writestring)   ; void _term_writestring(char*)
global _term_scroll:function (_term_scroll.end - _term_scroll)

extern _strlen                                          ; near
extern _move_cursor                                     ; near

SECTION .text   align=16
; Function _term_setxy: set term_row and term_col : BL=x, BH=y
_term_setxy: ; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        push    ebx
        
        movzx   eax, bl                                 ; x
        mov     dword [term_col], eax
        movzx   eax, bx                                 ; y
        shr     eax, 8
        mov     dword [term_row], eax
        
        ; Set cursor to row and col
        call    _move_cursor
        
        pop     ebx
        pop     eax
        leave
        ret
; _term_setxy End of function 

; Function _term_init: Initialize terminal
_term_init:; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        push    ebx
        push    ecx
        push    edx
        
        xor     ebx, ebx
        call    _term_setxy                             ; term_row = 0, term_col = 9
        mov     byte [term_color], 7                    ; bg - 0(black), fg - 7(grey)
        mov     dword [term_buffer], 0xB8000            ; [term_buffer] becoming origin or video mem
        movzx   edx, byte [term_color]                  ; set edx := term_color
        mov     eax, 0xB8000                            ; 0xB8000 - hardware video memory
        shl     edx, 8                                  ; edx ([term_color]) << 8
        or      edx, ' '
        mov     ecx, 2000                               ; VGA_HEIGHT * VGA_WIDTH
; loop for 2000 times
.L1:    mov     word [eax], dx                          ; [eax] = ' '|bgfg
        add     eax, 2                                  ; 1 buffer = 1 word (2 byte)
        ;cmp     eax, 757664                            ; 80*25*2byte = 4000byte + origin
        loop    .L1

        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        leave
        ret
.end:
; term_init End of function


; Function _term_setcolor: Set terminal background and foreground color (fg | bg << 4)
_term_setcolor:; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        
        mov     eax, dword [ebp+8]
        mov     byte [term_color], al

        pop     eax
        leave
        ret
.end:
; term_setcolor End of function


; Function _term_putentryat: Write an entry to terminal buffer
_term_putentryat:; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        push    ebx
        push    ecx
        push    edx

        movzx   eax, byte [ebp+8]                                ; c
        cmp     eax, 32                                          ; first printable char ' '
        jb      .leave
        cmp     eax, 126                                        ; last printable cahr '~'
        ja      .leave
        
        movzx   edx, byte [ebp+12]                               ; color
        shl     edx, 8
        or      edx, eax
        push    edx                                             ; keep the output char in stack
              
        mov     eax, dword [ebp+20]                             ; y
        mov     ebx, VGA_WIDTH
        mul     ebx                                             ; y * 80
        add     eax, dword [ebp+16]                             ; + x
        
        mov     ecx, dword [term_buffer]
        pop     edx                                             ; restore output from stack
        mov     word [ecx+eax*2], dx                            ; 2 byte per buffer

.leave: pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        leave
        ret
.end:
; term_putentryat End of function

; Function _term_putchar: write a char into terminal buffer
_term_putchar:; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        push    ebx
        
        ; Handle non-printable char
        movzx   eax, byte [ebp+8]                               ; x
        cmp     eax, 32                                         ; first printable char ' '
        jae     .L1
        
        cmp     eax, 10                                         ; if \n,
        jne     .leave
        mov     ebx, dword [term_row]
        shl     ebx, 8
        or      ebx, 0                                          ; term_col = 0
        call    _term_setxy
        ;mov     dword [term_col], 0                             ; term_col = 0
        mov     eax, dword [term_row]
        inc     eax                                             ; term_row++
        cmp     eax, VGA_HEIGHT                                 ; if term_row == VGA_HEIGHT
        jne     .L3
        call    _term_scroll                                    ; scroll 1 line up
        dec     eax                                             ; retain term_row at 24
.L3:    mov     ebx, eax                                        ; term_row = eax
        shl     ebx, 8
        or      ebx, dword [term_col]
        call    _term_setxy
        ;mov     dword [term_row], eax
        jmp     .leave
        
.L1:    cmp     eax, 126                                        ; last printable cahr '~'
        ja      .leave
        
.L2:    ; Call _term_putentryat
        mov     eax, dword [term_row]                           ; y
        push    eax
        mov     eax, dword [term_col]                           ; x
        push    eax
        movzx   eax, byte [term_color]
        push    eax
        movzx   eax, byte [ebp+8]                               ; c
        push    eax
        call    _term_putentryat
        add     esp, 16
        
        mov     eax, dword [term_col]                           ; if (++term_col == 80)
        inc     eax
        mov     ebx, dword [term_row]
        shl     ebx, 8
        or      ebx, eax                                        ; term_col = eax
        call    _term_setxy
        ;mov     dword [term_col], eax                           ; save to term_col
        cmp     eax, VGA_WIDTH
        jne     .leave
        mov     ebx, dword [term_row]
        shl     ebx, 8
        or      ebx, 0                                          ; term_col = 0
        call    _term_setxy
        ;mov     dword [term_col], 0                            ; term_col = 0
        
        ; TODO: if reaching end of buffer, pop buffer top line into history, shift remaining
        ;       lines 1 row up.
        mov     eax, dword [term_row]                           ; if (++term_row == 25)
        inc     eax
        mov     ebx, eax                                        ; term_row = eax
        shl     ebx, 8
        or      ebx, dword [term_col]
        call    _term_setxy
        ;mov     dword [term_row], eax                          ; save to term_row
        cmp     eax, VGA_HEIGHT
        jne     .leave
        mov     ebx, dword [term_col]                           ; term_row = 0
        call    _term_setxy
        ;mov     dword [term_row], 0
 
.leave: pop     ebx
        pop     eax
        leave
        ret
.end:
; term_putchar End of function

; Function _term_write: Write input buffer to terminal buffer for [size] long, at current x, y
_term_write:; Function begin
        push    ebp
        mov     ebp, esp
        sub     esp, 4                                  ; for keeping data pointer
        push    eax
        push    ebx
        push    ecx
        push    edx
        
        xor     eax, eax
        mov     ecx, dword [ebp+12]                     ; size
        mov     edx, dword [ebp+8]                      ; data (const char*)         
        mov     dword [ebp-4], edx                      ; keep the char pointer
        
.for:   mov     edx, dword [ebp-4]                      ; restore the char pointer
        push    ecx                                     ; keep the counter
        movzx   ebx, byte [edx+eax]                     ; edx+eax == data[i]
        inc     eax
        push    ebx
        call    _term_putchar
        add     esp, 4
        pop     ecx                                    ; restore counter
        loop    .for

        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        leave
        ret                                             ; 0133 _ C3
.end:        
; term_write End of function

; Function _term_writesring: Write a string to terminal buffer at current x, y
_term_writestring:; Function begin
        push    ebp
        mov     ebp, esp
        push    eax
        push    edx
        
        mov     edx, dword [ebp+8]                      ; data (char*)
        push    edx
        call    _strlen
        add     esp, 4
        test    eax, eax                                ; leave if zero
        jz      .leave
        
        push    eax                                     ; size
        mov     edx, dword [ebp+8]
        push    edx
        call    _term_write
        add     esp, 8

.leave: pop     edx
        pop     eax
        leave
        ret
.end:
; term_writestring End of function


;Function _term_scrolldown: move all line 1 above, and discard the top line
_term_scroll: ; Function begin
        enter   0, 0
        push    ecx
        
        mov     edi, 0xB8000                        ; origin of video mem
        mov     esi, 0xB80A0                        ; 2nd line
        mov     ecx, 0x780                          ; VGA_WIDTH*24
        rep     movsw
        
.leave: pop     ecx
        leave
        ret
.end:
; _term_scroll End of function

SECTION .data   align=1                                 ; section number 2, data


SECTION .bss    align=1                                 ; section number 3, bss
term_color:
        resb 1
term_buffer:
        resd 1
term_col:
        resd 1
term_row:
        resd 1
