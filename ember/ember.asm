bits 32

%define NULL 0
%define CS_VREDRAW 0x0001
%define CS_HREDRAW 0x0002
%define IDC_ARROW 32512
%define COLOR_WINDOW 5
%define WS_OVERLAPPEDWINDOW 0x00CF0000
%define WS_VISIBLE 0x10000000
%define WM_DESTROY 0x0002
%define WM_CLOSE 0x0010
%define SW_SHOWNORMAL 1

section .data
    section .data
    ClassName db "EMBERWindowClass", 0

section .bss
    hInstance resb 4
    hWnd resb 4

section .text
    global _emInit
    global _emCreateWindow
    global _emDestroyWindow
    global _emTerminate
    global _WndProc

    extern _GetModuleHandleW@4
    extern _LoadCursorW@8
    extern _RegisterClassExW@4
    extern _CreateWindowExW@48
    extern _ShowWindow@8
    extern _UpdateWindow@4
    extern _GetMessageA@16
    extern _TranslateMessage@4
    extern _DispatchMessageA@4
    extern _PostQuitMessage@4
    extern _DestroyWindow@4
    extern _DefWindowProcA@16
    extern _ExitProcess@4
    extern _UnregisterClassA@8
    extern _GetLastError@0 ; Import GetLastError

_emInit:
    PUSH EBP
    MOV EBP, ESP

    PUSH NULL
    CALL _GetModuleHandleW@4
    MOV [hInstance], EAX

    SUB ESP, 40
    MOV EBX, ESP

    MOV DWORD [EBX + 4 * 0], 44              ; cbSize
    MOV DWORD [EBX + 4 * 1], CS_VREDRAW | CS_HREDRAW ; style
    MOV DWORD [EBX + 4 * 2], _WndProc         ; lpfnWndProc
    MOV DWORD [EBX + 4 * 3], 0              ; cbClsExtra
    MOV DWORD [EBX + 4 * 4], 0              ; cbWndExtra
    MOV EAX, [hInstance]                    ; hInstance
    MOV DWORD [EBX + 4 * 5], EAX
    MOV DWORD [EBX + 4 * 6], NULL             ; hIcon
    PUSH IDC_ARROW
    PUSH NULL
    CALL _LoadCursorW@8
    MOV DWORD [EBX + 4 * 7], EAX             ; hCursor
    MOV DWORD [EBX + 4 * 8], COLOR_WINDOW + 1 ; hbrBackground
    MOV DWORD [EBX + 4 * 9], NULL             ; lpszMenuName
    LEA EAX, [ClassName]                    ; lpszClassName
    MOV DWORD [EBX + 4 * 10], EAX

    PUSH EBX
    CALL _RegisterClassExW@4
    TEST EAX, EAX
    JZ .initFail

    ADD ESP, 40
    MOV EAX, 1
    MOV ESP, EBP
    POP EBP
    RET
.initFail:
    CALL _GetLastError@0 ; Get the error code
    ; At this point, if you're using a debugger, you can inspect the value in EAX
    ADD ESP, 40
    MOV EAX, 0
    MOV ESP, EBP
    POP EBP
    RET

_emCreateWindow:
    PUSH EBP
    MOV EBP, ESP

    PUSH NULL
    PUSH DWORD [hInstance]
    PUSH NULL
    PUSH NULL
    PUSH DWORD [EBP + 16]
    PUSH DWORD [EBP + 12]
    PUSH DWORD [EBP + 24]
    PUSH DWORD [EBP + 20]
    PUSH WS_OVERLAPPEDWINDOW | WS_VISIBLE
    PUSH DWORD [EBP + 8]
    PUSH ClassName
    PUSH NULL
    CALL _CreateWindowExW@48

    MOV [hWnd], EAX

    PUSH SW_SHOWNORMAL
    PUSH DWORD [hWnd]
    CALL _ShowWindow@8

    PUSH DWORD [hWnd]
    CALL _UpdateWindow@4

    MOV EAX, [hWnd]

    MOV ESP, EBP
    POP EBP
    RET

_emDestroyWindow:
    PUSH EBP
    MOV EBP, ESP
    PUSH DWORD [hWnd]
    CALL _DestroyWindow@4
    MOV ESP, EBP
    POP EBP
    RET

_emTerminate:
    PUSH EBP
    MOV EBP, ESP
    PUSH DWORD [hInstance]
    PUSH ClassName
    CALL _UnregisterClassA@8
    MOV ESP, EBP
    POP EBP
    RET

_WndProc:
    PUSH EBP
    MOV EBP, ESP
    MOV EAX, [EBP+12]       ; Get message

    cmp EAX, WM_DESTROY
    JE WM_DESTROY_HANDLER

    cmp EAX, WM_CLOSE
    JE WM_CLOSE_HANDLER

    PUSH DWORD [EBP+20]     ; lParam
    PUSH DWORD [EBP+16]     ; wParam
    PUSH DWORD [EBP+12]     ; message
    PUSH DWORD [EBP+8]      ; hwnd
    CALL _DefWindowProcA@16
    JMP END_WNDPROC

WM_DESTROY_HANDLER:
    PUSH 0
    CALL _PostQuitMessage@4
    XOR EAX, EAX
    JMP END_WNDPROC

WM_CLOSE_HANDLER:
    PUSH DWORD [EBP+8]
    CALL _DestroyWindow@4
    XOR EAX, EAX

END_WNDPROC:
    MOV ESP, EBP
    POP EBP
    RET 16