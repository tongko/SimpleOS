#if !defined(__cplusplus)
#include <stdbool.h> /* C doesn't have booleans by default. */
#endif
#include <stddef.h>
#include <stdint.h>

/* Check if the compiler thinks we are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

#include "stdlib.h"
#include "term.h"

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
	return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
	return (uint16_t) uc | (uint16_t) color << 8;
}

size_t term_row;
size_t term_col;
uint8_t term_color;
uint16_t* term_buffer;

void term_init(void) {
    uint16_t entry = vga_entry(' ', term_color);
	term_row = 0;
	term_col = 0;
	term_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	term_buffer = (uint16_t*) 0xB8000;
	for (size_t i = 0; i < VGA_HEIGHT * VGA_WIDTH; i++) {
        term_buffer[i] = entry;
	}
/*	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			term_buffer[index] = entry;
		}
	}*/
}

void term_setcolor(uint8_t color) {
	term_color = color;
}

void term_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	term_buffer[index] = vga_entry(c, color);
}

void term_putchar(char c) {
	term_putentryat(c, term_color, term_col, term_row);
	if (++term_col == VGA_WIDTH) {
		term_col = 0;
		if (++term_row == VGA_HEIGHT)
			term_row = 0;
	}
}

void term_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++)
		term_putchar(data[i]);
}

void term_writestring(const char* data) {
	term_write(data, strlen(data));
}
