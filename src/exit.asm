bits 32

section .data

section .bss

section .text

extern ExitProcess

global __start

__start:
    PUSH 0
    CALL ExitProcess