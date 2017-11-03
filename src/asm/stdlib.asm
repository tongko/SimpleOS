[bits 32]

VGA_WIDTH	equ	80

global _strlen:function (_strlen.end - _strlen)
global _move_cursor:function (_move_cursor.end - _move_cursor)
global _itoa:function (_itoa.end - _itoa)

SECTION .text	align=16

; Function _strlen: Measure the length of given string, in number of char. (ANSI)
_strlen: ; Function begin - _strlen(const char *)
		push	ebp
		mov		ebp, esp
		push	edx

		mov		edx, dword [ebp+8]						; const char * (param)
		xor		eax, eax								; comparand = 0			 

.L1:	cmp		byte [edx+eax], 0
		je		.leave
		inc		eax
		jmp		.L1

.leave: pop		edx
		leave
		ret
.end:
; strlen End of function

; Function _move_cursor: Move cursor to given x and y position
_move_cursor: ; Function begin - _move_cursor(word xy): BL=x, BH=y
		push	ebp
		mov		ebp, esp
		push	eax
		push	ebx
		push	ecx
		push	edx
		 
	; position = y * VGA_WIDTH + x
		movzx   eax, bh
		mov		ecx, VGA_WIDTH
		mul		ecx
		movzx   ecx, bl
		;shr		ecx, 8
		add		eax, ecx
		mov		ecx, eax

		; cursor low port to VGA index register
		mov		eax, 0x0F
		mov		edx, 0x3D4
		out		dx, al

	; cursor low position to VGA data register
		mov		eax, ecx
		mov		edx, 0x3D5
		out		dx, al
 
	; cursor high port to VGA index register
		mov		eax, 0x0E
		mov		edx, 0x3D4
		out		dx, al
 
	; cursor high position to VGA data register
		mov		eax, ecx
		shr		eax, 8
		mov		edx, 0x3D5
		out		dx, al

.leave: pop		edx
		pop		ecx
		pop		ebx
		pop		eax
		leave
		ret
.end:
; _move_cursor End of function

; Function _itoa: Convert number to string
_itoa:
		enter   4, 0							; 4 byte for local var
		push	ebx
		push	edx

		mov		eax, dword [ebp+8]
		mov		ebx, dword [ebp+12]
		lea		esi, [ebx+10]			 ; mov to 10th byte of the buffer
		mov		ecx, 10
		mov		dword [ebp-4], 0				; init local var to 0

.L1:	xor		edx, edx
		idiv	ecx
		add		edx, 0x30
		dec		esi
		mov		byte [esi], dl
		inc		dword [ebp-4]

		cmp		eax, 0
		jne		.L1

		mov		eax, esi
		mov		ecx, [ebp-4]

		pop		edx
		pop		ebx
		leave
		ret
.end:
; _itoa End of function

;SECTION .data   align=1 noexecute							 ; section number 2, data

;SECTION .bss	align=1 noexecute							 ; section number 3, bss

