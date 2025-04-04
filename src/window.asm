bits 32

%define NULL 0
%define CS_VREDRAW 0x0001
%define CS_HREDRAW 0x0002
%define IDC_ARROW 32512
%define COLOR_WINDOW 5
%define WS_OVERLAPPEDWINDOW 0x00CF0000
%define WS_VISIBLE 0x10000000
%define SW_SHOWNORMAL 1
%define WM_DESTROY 0x0002
%define WM_CLOSE 0x0010

section .data
    ClassName db "WinClass", 0
    WindowTitle db "Assembly window!", 0

section .bss
    hInstance resb 4
    hWnd resb 4
    msg resb 28
    wndClass resb 40

section .text
    global __start
    extern _GetModuleHandleA@4
    extern _LoadCursorA@8
    extern _RegisterClassA@4
    extern _CreateWindowExA@48
    extern _ShowWindow@8
    extern _UpdateWindow@4
    extern _GetMessageA@16
    extern _TranslateMessage@4
    extern _DispatchMessageA@4
    extern _PostQuitMessage@4
    extern _DestroyWindow@4
    extern _DefWindowProcA@16
    extern _ExitProcess@4

__start:
    PUSH NULL
    CALL _GetModuleHandleA@4
    MOV [hInstance], EAX

    MOV DWORD [wndClass + 4 * 0], CS_VREDRAW | CS_HREDRAW
    MOV DWORD [wndClass + 4 * 1], _WndProc
    MOV DWORD [wndClass + 4 * 2], NULL
    MOV DWORD [wndClass + 4 * 3], NULL
    MOV DWORD [wndClass + 4 * 4], hInstance
    MOV DWORD [wndClass + 4 * 5], NULL

    PUSH IDC_ARROW
    PUSH NULL
    CALL _LoadCursorA@8

    MOV DWORD [wndClass + 4 * 6], EAX
    MOV DWORD [wndClass + 4 * 7], COLOR_WINDOW + 1
    MOV DWORD [wndClass + 4 * 8], NULL
    MOV DWORD [wndClass + 4 * 9], ClassName

    PUSH wndClass
    CALL _RegisterClassA@4

    PUSH NULL
    PUSH hInstance
    PUSH NULL
    PUSH NULL
    PUSH 600
    PUSH 600
    PUSH 100
    PUSH 100
    PUSH WS_OVERLAPPEDWINDOW | WS_VISIBLE
    PUSH WindowTitle
    PUSH ClassName
    PUSH NULL
    CALL _CreateWindowExA@48
    MOV [hWnd], EAX

    PUSH SW_SHOWNORMAL
    PUSH dword [hWnd]
    CALL _ShowWindow@8

    PUSH dword [hWnd]
    CALL _UpdateWindow@4

MessageLoop:
    PUSH NULL
    PUSH NULL
    PUSH NULL
    PUSH msg
    CALL _GetMessageA@16
    TEST EAX, EAX
    JZ ExitProgram

    PUSH msg
    CALL _TranslateMessage@4

    PUSH msg
    CALL _DispatchMessageA@4

    JMP MessageLoop

ExitProgram:
    PUSH 0
    CALL _ExitProcess@4

_WndProc:
    PUSH EBP
    MOV EBP, ESP

    MOV EAX, [EBP+12]
    CMP EAX, WM_DESTROY 
    JE WM_DESTROY_HANDLER
    CMP EAX, WM_CLOSE
    JE WM_CLOSE_HANDLER 
    
    PUSH DWORD [EBP+20]
    PUSH DWORD [EBP+16]
    PUSH DWORD [EBP+12]
    PUSH DWORD [EBP+8]
    CALL _DefWindowProcA@16
    JMP END_WNDPROC
    
WM_DESTROY_HANDLER:
    PUSH DWORD 0
    CALL _PostQuitMessage@4
    XOR EAX, EAX
    JMP END_WNDPROC
    
WM_CLOSE_HANDLER:
    PUSH DWORD [EBP+8]
    CALL _DestroyWindow@4
    XOR EAX, EAX
    JMP END_WNDPROC
    
END_WNDPROC:
    MOV ESP, EBP
    POP EBP
    RET 16