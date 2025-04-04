bits 32

section .data
    helloMsg db "Hello, World!", 0Dh, 0Ah
    helloLen equ $ - helloMsg

section .bss
    charsWritten RESB 4

section .text

extern _GetStdHandle@4
extern _WriteConsoleA@20
extern _ExitProcess@4

global __start

__start:
    PUSH byte -11
    CALL _GetStdHandle@4
    MOV EBX, EAX
    PUSH byte 0
    PUSH dword charsWritten
    PUSH byte helloLen
    PUSH dword helloMsg
    PUSH EBX
    CALL _WriteConsoleA@20
    PUSH byte 0
    CALL _ExitProcess@4