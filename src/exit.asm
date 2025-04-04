bits 32

section .data

section .bss

section .text

extern _ExitProcess@4

global __start

__start:
    PUSH 0
    CALL _ExitProcess@4