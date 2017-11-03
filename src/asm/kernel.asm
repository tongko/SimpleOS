[bits 32]

global kernel_main:function (kernel_main.end - kernel_main)

extern _term_writestring
extern _term_init
extern _term_scroll

SECTION .text   align=16									; section number 1, code

kernel_main:; Function begin
		enter	0, 0

		call	_term_init

		push	version
		call	_term_writestring
		add	 esp, 4
		push	cpright
		call	_term_writestring
		add	 esp, 4

		leave
		ret
.end:
; kernel_main End of function

SECTION .data   align=1									; section number 2, data

version db "Simple OS Version 0.0.3", 10, 0
cpright db "Sin Hing 2017 all rights reserved", 10, 0

SECTION .bss	align=1									; section number 3, bss


SECTION .rodata align=4									; section number 4, const

welcome_string:											; byte
		db 53H, 69H, 6DH, 70H, 6CH, 65H, 20H, 4FH		; 0000 _ Simple O
		db 53H, 20H, 56H, 65H, 72H, 73H, 69H, 6FH		; 0008 _ S Versio
		db 6EH, 20H, 30H, 2EH, 30H, 2EH, 33H, 0AH		; 0010 _ n 0.0.3.
		db 53H, 69H, 6EH, 20H, 48H, 69H, 6EH, 67H		; 0018 _ Sin Hing
		db 20H, 61H, 6CH, 6CH, 20H, 72H, 69H, 67H		; 0020 _  all rig
		db 68H, 74H, 73H, 20H, 72H, 65H, 73H, 65H		; 0028 _ hts rese
		db 72H, 76H, 65H, 64H, 2EH, 0AH, 00H			; 0030 _ rved...
