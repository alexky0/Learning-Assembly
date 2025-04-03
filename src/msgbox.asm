bits 32

%define MB_OK 0x00000000
%define MB_ICONINFORMATION 0x00000040
%define MB_DEFBUTTON1 0x00000000

section .data
    title db "Title", 0
    text db "Text", 0

section .bss

section .text
global __start

extern _MessageBoxA@16
extern _ExitProcess@4

__start:
    PUSH DWORD MB_OK | MB_ICONINFORMATION | MB_DEFBUTTON1
    PUSH title
    PUSH text
    PUSH 0
    CALL _MessageBoxA@16

    PUSH dword 0
    CALL _ExitProcess@4